//
//  OtpVerificationViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import SVPinView

class OtpVerificationViewController: UIViewController, Storyboarded {

    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var resendCodeBtn: UIButton!
    
    var viewModel: OtpVerificationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPinView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
    }
    
    private func setup() {
        titleDescLabel.text = "Enter the 4-digit code sent to you at \(viewModel.phoneNumber ?? "")"
        resendCodeBtn.rounded()
    }
    
    private func setupPinView() {
       
        pinView.keyboardType = .numberPad
        pinView.becomeFirstResponderAtIndex = 0
        pinView.didFinishCallback = { [weak self] pin in
            self?.signIn(pin: pin)
        }
    }
    
    private func signIn(pin: String) {
        self.showProgressHud()
        FirebaseService.shared.signInWith(pin) { user in
            self.hideProgressHud()
            guard let nav = self.navigationController else {return}
            let vc = BaseTabbarCoordinator.init(navigationController: nav).getMainView()
            appdelegate.window?.rootViewController = vc
        } failure: { error in
            self.hideProgressHud()
            self.pinView.clearPin()
        }
    }

    @IBAction func resendCodeAction(_ sender: Any) {
        self.showProgressHud()
        FirebaseService.shared.verifyPhone(viewModel.phoneNumber ?? "") {
            self.hideProgressHud()
            self.pinView.clearPin()
        } failure: { error in
            self.hideProgressHud()
        }

    }
}
