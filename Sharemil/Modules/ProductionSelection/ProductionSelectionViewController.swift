//
//  ProductionSelectionViewController.swift
//  Sharemil
//
//  Created by Lizan on 15/11/2022.
//

import UIKit

class ProductionSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func productionAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "ENV") == "D" {
            UserDefaults.standard.set("P", forKey: "ENV")
            self.loadRegistration()
        } else {
            UserDefaults.standard.set("P", forKey: "ENV")
            if let _ = UserDefaults.standard.string(forKey: StringConstants.verificationToken) {
                self.loadHome()
            } else {
                self.loadRegistration()
            }
        }
    }
    
    @IBAction func developmentAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "ENV") == "P" {
            UserDefaults.standard.set("D", forKey: "ENV")
            self.loadRegistration()
        } else {
            UserDefaults.standard.set("D", forKey: "ENV")
            if let _ = UserDefaults.standard.string(forKey: StringConstants.verificationToken) {
                self.loadHome()
            } else {
                self.loadRegistration()
            }
        }
    }
    
    private func loadRegistration() {
        let navigation = UINavigationController()
        let registrationCoordinator = RegistrationCoordinator.init(navigationController: navigation)
        registrationCoordinator.start()
        appdelegate.window?.rootViewController = navigation
    }
    
    private func loadHome() {
        let navigation = UINavigationController()
        let homeCoordinator = BaseTabbarCoordinator.init(navigationController: navigation)
        appdelegate.window?.rootViewController = homeCoordinator.getMainView()
    }
    
}
