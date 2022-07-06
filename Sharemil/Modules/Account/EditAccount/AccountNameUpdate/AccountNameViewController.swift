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
    }
    
    var currentNameType: AccountNameType = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        self.nameLabel.text = currentNameType == .first ? "First Name" : "Last Name"
        self.nameFIeld.placeholder = currentNameType == .first ? "Enter your first name." : "Enter your last name."
        self.updateBtn.setTitle(currentNameType == .first ? "Update First Name" : "Update Last Name", for: .normal)
    }

    @IBAction func clearAction(_ sender: Any) {
        
    }
    
    @IBAction func updateAction(_ sender: Any) {
        
    }
}
