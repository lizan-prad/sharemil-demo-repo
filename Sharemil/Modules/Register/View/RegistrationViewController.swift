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
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Mixpanel

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
    
    var selectedCOuntry: Country?
    
    fileprivate var currentNonce: String?

    
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
            Mixpanel.mainInstance().track(event: "Initiated registration", properties: [
                "phone": self.phoneField.text ?? ""
                ])
            guard let nav = self.navigationController, let number = self.phoneField.phoneNumber?.nationalNumber, let code = self.phoneField.phoneNumber?.countryCode else {return}
            let coordinator = OtpVerificationCoordinator.init(navigationController: nav)
            coordinator.phoneNumber = "+\(code)\(number)"
            coordinator.start()
        }
        
        viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
    }
    
    private func setup() {
        countryList.delegate = self
        phoneField.delegate = self
        self.nextBtn.disable()
        self.errorLabel.text = ""
    }
    
    private func setupViews() {
        googleBtn.addStandardBorder()
        phoneContainer.addStandardBorder()
        appleBtn.addStandardBorder()
        self.selectedCOuntry = countryList.getCountry(code: self.phoneField.currentRegion)
        self.flagBtn.setTitle(countryList.getCountry(code: self.phoneField.currentRegion )?.flag ?? "", for: .normal)
        self.googleBtn.addTarget(self, action: #selector(googleSignAction), for: .touchUpInside)
        self.appleBtn.addTarget(self, action: #selector(appleSignAction), for: .touchUpInside)
        self.phoneField.placeholder = "+" + (self.selectedCOuntry?.phoneExtension ?? "") + "XXXXXXXXXX"
    }
    
    @objc func appleSignAction() {
        self.startSignInWithAppleFlow()
    }
    
    @objc func googleSignAction() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self)
//        GIDSignIn.sharedInstance.signIn(
//            with: GIDConfiguration.init(clientID: StringConstants.googleClientID),
//            presenting: self) { user, error in
//                guard let signInUser = user else {return}
//                print(signInUser)
//            }
    }
    
    private func setupPhoneField() {
//        phoneField.withExamplePlaceholder = true
        phoneField.textContentType = .telephoneNumber
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
        if (phoneField.text?.count ?? 0) > 0 && !(phoneField.text?.contains(self.selectedCOuntry?.phoneExtension ?? "") ?? false) {
            self.phoneField.text = "+" + (self.selectedCOuntry?.phoneExtension ?? "") + (self.phoneField.text ?? "")
        }
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

//MARK: Apple Login

extension RegistrationViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
              if (error != nil) {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                  print(error?.localizedDescription)
              return
            }
            print("Apple sign in successful")
          }
        }
      }
}

extension RegistrationViewController: CountryListDelegate {
    //MARK: Get the selected country
    func selectedCountry(country: Country) {
        self.selectedCOuntry = country
        self.flagBtn.setTitle(country.flag ?? "", for: .normal)
        self.phoneField._defaultRegion = country.countryCode
        self.phoneField.partialFormatter.defaultRegion = country.countryCode
        self.phoneField.text = "+" + country.phoneExtension
//        self.phoneField.updatePlaceholder()
        
    }
}

extension RegistrationViewController: UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.typingAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        let protectedRange = NSMakeRange(0, (self.selectedCOuntry?.phoneExtension.count ?? 0) + 1)
        let intersection = NSIntersectionRange(protectedRange, range)
        if intersection.length > 0 {

            return false
        }
       
        return true
    }
}

extension RegistrationViewController {
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
