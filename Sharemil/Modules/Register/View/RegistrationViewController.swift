//
//  RegistrationViewController.swift
//  Sharemil
//
//  Created by Macbook Pro on 09/06/2022.
//

import UIKit
import PhoneNumberKit
import CountryList
import GoogleSignIn

class RegistrationViewController: UIViewController, Storyboarded {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
  
    @IBOutlet weak var phoneContainer: UIView!
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    @IBOutlet weak var flagBtn: UIButton!
    
    var countryList = CountryList()
    
    var viewModel: RegistrationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setup()
        setupPhoneField()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.loading.bind { status in
            (status ?? false) ? self.showProgressHud() : self.hideProgressHud()
        }
        
        viewModel.signInSuccess.bind { msg in
            guard let nav = self.navigationController, let number = self.phoneField.phoneNumber?.nationalNumber, let code = self.phoneField.phoneNumber?.countryCode else {return}
            let coordinator = OtpVerificationCoordinator.init(navigationController: nav)
            coordinator.phoneNumber = "+\(code)\(number)"
            coordinator.start()
        }
        
        viewModel.error.bind { msg in
            print(msg)
        }
    }
    
    private func setup() {
        countryList.delegate = self
        self.nextBtn.disable()
        self.errorLabel.text = ""
    }
    
    private func setupViews() {
        googleBtn.addStandardBorder()
        phoneContainer.addStandardBorder()
        appleBtn.addStandardBorder()
        self.flagBtn.setTitle(countryList.getCountry(code: self.phoneField.currentRegion )?.flag ?? "", for: .normal)
        self.googleBtn.addTarget(self, action: #selector(googleSignAction), for: .touchUpInside)
    }
    
    @objc func googleSignAction() {
        GIDSignIn.sharedInstance.signIn(
            with: GIDConfiguration.init(clientID: StringConstants.googleClientID),
            presenting: self) { user, error in
                guard let signInUser = user else {return}
                print(signInUser)
            }
    }
    
    private func setupPhoneField() {
        phoneField.withExamplePlaceholder = true
        phoneField.isPartialFormatterEnabled = true
        phoneField.maxDigits = 10
        self.presentationController?.delegate = self
        phoneField.delegate = self
        phoneField.addTarget(self, action: #selector(textCHanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @objc func textCHanged() {
           
           if !phoneField.isValidNumber {
               self.errorLabel.text = StringConstants.ErrorMessages.invalidNumber
           } else {
               self.errorLabel.text = ""
               
           }
        phoneField.isValidNumber ? nextBtn.enable() : nextBtn.disable()
       }
    
    
    @IBAction func flagAction(_ sender: Any) {
        self.openCountryList()
    }
    
    
    @objc func openCountryList() {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func nextAction(_ sender: Any) {
        guard let number = phoneField.phoneNumber?.nationalNumber, let code = phoneField.phoneNumber?.countryCode else {return}
        self.viewModel.verifyPhone("+\(code)\(number)")
    }
}

extension RegistrationViewController: CountryListDelegate {
    
    func selectedCountry(country: Country) {
        self.flagBtn.setTitle(country.flag ?? "", for: .normal)
        self.phoneField.text = "+" + country.phoneExtension
        self.phoneField._defaultRegion = country.countryCode
        self.phoneField.partialFormatter.defaultRegion = country.countryCode
        self.phoneField.updatePlaceholder()
        
    }
}

extension RegistrationViewController: UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

}
