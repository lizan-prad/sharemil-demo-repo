//
//  AccountViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var viewModel: AccountViewModel!
    
    var user: UserModel? {
        didSet {
            self.nameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AccountViewModel()
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
            self.user = user
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.fetchUserProfile()
    }
    
    @IBAction func editAction(_ sender: Any) {
        guard let nav = self.navigationController else {return}
        let coordinator = EditAccountCoordinator.init(navigationController: nav)
        let vc = UINavigationController.init(rootViewController: coordinator.getMainView())
                                
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc , animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: StringConstants.verificationToken)
        appdelegate.loadRegistration()
    }
    

}
