//
//  EditAccountViewController.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//

import UIKit

class EditAccountViewController: UIViewController, Storyboarded {

    @IBOutlet weak var emailStack: UIView!
    @IBOutlet weak var phoneStack: UIView!
    @IBOutlet weak var lastNameStack: UIView!
    @IBOutlet weak var firstNameStack: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var viewModel: EditAccountViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       
    }
    
    private func setup() {
        firstNameStack.isUserInteractionEnabled = true
        firstNameStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openFirstNameEdit)))
        
        lastNameStack.isUserInteractionEnabled = true
        lastNameStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openLastNameEdit)))
    }
    
    @objc private func openFirstNameEdit() {
        let vc = UIStoryboard.init(name: "AccountName", bundle: nil).instantiateViewController(withIdentifier: "AccountNameViewController") as! AccountNameViewController
        vc.currentNameType = .first
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openLastNameEdit() {
        let vc = UIStoryboard.init(name: "AccountName", bundle: nil).instantiateViewController(withIdentifier: "AccountNameViewController") as! AccountNameViewController
        vc.currentNameType = .last
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
