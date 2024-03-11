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

    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var legalView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
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
            Mixpanel.mainInstance().identify(distinctId: user?.id ?? "") {
                print("doneeee")
            }
            Mixpanel.mainInstance().people.set(properties: [ "$distinct_id": user?.id ?? "", "$name": "\(user?.firstName ?? "") \(user?.lastName ?? "")", "$email": user?.email ?? "", "$avatar" : user?.profileImage ?? "", "$phone" : user?.phoneNumber ?? ""])
        }
    }
    
    var deleteSuccess: String?{
        didSet{
            logoutAction() 
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView.isHidden = (UserDefaults.standard.string(forKey: StringConstants.userIDToken) != StringConstants.staticToken)
        self.viewModel = AccountViewModel()
        profilePic.rounded()
        profilePic.clipsToBounds = true
        bindViewModel()
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openEnvSettings)))
        
        supportView.isUserInteractionEnabled = true
        supportView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(supportAction)))
        
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(logoutAction)))
        
        legalView.isUserInteractionEnabled = true
        legalView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleStaticContent2)))
        
        termsView.isUserInteractionEnabled = true
        termsView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleStaticContent)))
        
        
        deleteAccountView.isUserInteractionEnabled = true
        deleteAccountView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleAccountDelete)))
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        appdelegate.loadRegistration()
    }
    
    @objc func handleAccountDelete(){
        self.alertWithOkCancel(message: "Are you sure you want to delete the account?",okAction: {
            self.viewModel.deleteUserProfile()
        })
      
    }
    
    @objc func handleStaticContent2(){
        let vc = UIStoryboard.init(name: "StaticPage", bundle: nil).instantiateViewController(identifier: "StaticPageViewController") as! StaticPageViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            vc.urlLink = "https://doc-hosting.flycricket.io/sharemil-terms-of-use/bf93f32b-e2fb-4fdb-bedf-ec348d9ab4cf/terms"
            vc.pageTitle = "Terms and Conditions"
        })
        self.present(vc , animated: true)
    }
    
    @objc func handleStaticContent(){
        let vc = UIStoryboard.init(name: "StaticPage", bundle: nil).instantiateViewController(identifier: "StaticPageViewController") as! StaticPageViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            vc.urlLink = "https://doc-hosting.flycricket.io/sharemil-privacy-policy/cc3c8099-81ac-4e30-9f46-22a2f387d911/privacy"
            vc.pageTitle = "Privacy Policy"
        })
        self.present(vc , animated: true)
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
        self.viewModel.deleteSuccess.bind{ success in
            self.deleteSuccess = success
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
    
    @objc func logoutAction() {
        UserDefaults.standard.set(nil, forKey: StringConstants.userIDToken)
        UserDefaults.standard.set(nil, forKey: StringConstants.verificationToken)
        appdelegate.loadRegistration()
    }
    
    @objc func supportAction() {
        let coordinator = OtherHelpCoordinator.init(navigationController: UINavigationController())
        self.present(coordinator.getMainView(), animated: true)
    }

}
