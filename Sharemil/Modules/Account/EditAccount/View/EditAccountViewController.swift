//
//  EditAccountViewController.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//

import UIKit

class EditAccountViewController: UIViewController, Storyboarded {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var emailVerification: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var emailStack: UIView!
    @IBOutlet weak var phoneStack: UIView!
    @IBOutlet weak var lastNameStack: UIView!
    @IBOutlet weak var firstNameStack: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var viewModel: EditAccountViewModel!
    var user: UserModel? {
        didSet {
            if user?.profileImage == nil {
                profilePic.image = UIImage.init(named: "profile-placeholder")
            } else {
            profilePic.sd_setImage(with: URL.init(string: user?.profileImage ?? ""))
            }
            self.firstName.text = user?.firstName
            self.lastName.text = user?.lastName
            self.phoneLabel.text = user?.phoneNumber
            self.email.text = user?.email
            self.emailVerification.isHidden = user?.email == ""
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            self.profilePic.image = selectedImage
            self.showProgressHud()
            FirebaseService.shared.uploadMedia(selectedImage ?? UIImage(), name: "profile_pic") { url in
                self.hideProgressHud()
                let param: [String: Any] =  [
                    "profileImage": url ?? ""
                ]
                self.viewModel.updateUserProfile(param: param)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        self.viewModel.fetchUserProfile()
    }
    
    private func setup() {
        firstNameStack.isUserInteractionEnabled = true
        firstNameStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openFirstNameEdit)))
        
        lastNameStack.isUserInteractionEnabled = true
        lastNameStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openLastNameEdit)))
        
        emailStack.isUserInteractionEnabled = true
        emailStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openEmailEdit)))
        profilePic.rounded()
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(editAction)))
    }
    
    @objc func editAction() {
        let imagePicker = ImagePickerManager()
        imagePicker.viewController = self
        imagePicker.pickImage(self){ image in
            self.selectedImage = image
        }
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
    
    @objc private func openFirstNameEdit() {
        let vc = UIStoryboard.init(name: "AccountName", bundle: nil).instantiateViewController(withIdentifier: "AccountNameViewController") as! AccountNameViewController
        vc.currentNameType = .first
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openEmailEdit() {
        let vc = UIStoryboard.init(name: "AccountName", bundle: nil).instantiateViewController(withIdentifier: "AccountNameViewController") as! AccountNameViewController
        vc.currentNameType = .email
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
