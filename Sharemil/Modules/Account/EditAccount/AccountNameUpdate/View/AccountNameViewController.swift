//
//  AccountNameViewController.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//

import UIKit

class AccountNameViewController: UIViewController {

    @IBOutlet weak var nameFIeld: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    
    enum AccountNameType {
        case first
        case last
        case email
    }
    
    var viewModel: AccountNameViewModel!
    
    var currentNameType: AccountNameType = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AccountNameViewModel()
        setup()
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.user.bind { user in
            self.showToastMsg("Updated successfully!", state: .success, location: .bottom)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        self.nameLabel.text = currentNameType == .first ? "First Name" : (currentNameType == .last ? "Last Name" : "Email")
        self.nameFIeld.placeholder = currentNameType == .first ? "Enter your first name." : (currentNameType == .last ? "Enter your last name." : "Enter your email.")
        self.updateBtn.setTitle(currentNameType == .first ? "Update First Name" : (currentNameType == .last ? "Update Last Name" : "Update Email"), for: .normal)
    }

    @IBAction func clearAction(_ sender: Any) {
        self.nameFIeld.text = nil
    }
    
    @IBAction func updateAction(_ sender: Any) {
        if currentNameType == .email {
            if isValidEmail(nameFIeld.text ?? "") {
                let param: [String: Any] = self.currentNameType == .first ? [
                    "firstName": self.nameFIeld.text ?? ""
                ] : (currentNameType == .last ? [  "lastName": self.nameFIeld.text ?? "" ] : [  "email": self.nameFIeld.text ?? "" ] )
                self.viewModel.updateUserProfile(param: param)
            } else {
                self.showToastMsg("Enter a valid email address", state: .error, location: .bottom)
            }
        } else {
            let param: [String: Any] = self.currentNameType == .first ? [
                "firstName": self.nameFIeld.text ?? ""
            ] : (currentNameType == .last ? [  "lastName": self.nameFIeld.text ?? "" ] : [  "email": self.nameFIeld.text ?? "" ] )
            self.viewModel.updateUserProfile(param: param)
        }
        
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
