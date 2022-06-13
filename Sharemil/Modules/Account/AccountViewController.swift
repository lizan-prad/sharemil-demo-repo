//
//  AccountViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: StringConstants.verificationToken)
        appdelegate.loadRegistration()
    }
    

}
