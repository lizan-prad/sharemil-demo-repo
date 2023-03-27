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
        bindViewModel()
        setup()
        setupPinView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
    }
    
    private func bindViewModel() {
        viewModel.loading.bind { status in
            (status ?? false) ? self.showProgressHud() : self.hideProgressHud()
        }
        
        viewModel.otpSuccess.bind { user in
            guard let nav = self.navigationController else {return}
            let vc = BaseTabbarCoordinator.init(navigationController: nav).getMainView()
            appdelegate.window?.rootViewController = vc
        }
        
        viewModel.resendSuccess.bind { msg in
            self.pinView.clearPin()
            self.showToastMsg(StringConstants.SuccessMessages.otpResent, state: .success, location: .bottom)
        }
        
        viewModel.error.bind { msg in
            self.pinView.clearPin()
            self.view.endEditing(true)
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
    }
    
    private func setup() {
        titleDescLabel.text = "Enter the 6-digit code sent to you at \(viewModel.phoneNumber ?? "")"
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
        self.viewModel.verifyOTP(pin)
    }

    @IBAction func resendCodeAction(_ sender: Any) {
        self.viewModel.resendOTP()

    }
}
