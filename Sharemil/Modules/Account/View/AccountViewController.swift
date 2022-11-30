//
//  AccountViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import SDWebImage
import Mixpanel

class AccountViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var viewModel: AccountViewModel!
    
    var count = 0
    
    var user: UserModel? {
        didSet {
            if user?.profileImage == nil {
                profilePic.image = UIImage.init(named: "profile-placeholder")
            } else {
            profilePic.sd_setImage(with: URL.init(string: user?.profileImage ?? ""))
            }
            self.nameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            Mixpanel.mainInstance().people.set(properties: [ "$first_name": "\(user?.firstName ?? "")", "$last_name" : "\(user?.lastName ?? "")", "$email": user?.email ?? "", "$avatar" : user?.profileImage ?? "", "$phone" : user?.phoneNumber ?? ""])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AccountViewModel()
        profilePic.rounded()
        bindViewModel()
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openEnvSettings)))
    }
    
    @objc func openEnvSettings() {
        count += 1
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.count = 0
        }
        if count == 5 {
            loadProductionSelection()
        }
    }
    
    private func loadProductionSelection() {
        let vc = UIStoryboard.init(name: "ProductionSelection", bundle: nil).instantiateViewController(identifier: "ProductionSelectionViewController") as! ProductionSelectionViewController
        self.present(vc , animated: true)
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
