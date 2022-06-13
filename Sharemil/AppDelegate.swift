//
//  AppDelegate.swift
//  Sharemil
//
//  Created by Lizan on 08/06/2022.
//

import UIKit
import IQKeyboardManager
import FirebaseCore

let appdelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        if #available(iOS 13.0, *) {
                    window?.overrideUserInterfaceStyle = .light
                }
        if let _ = UserDefaults.standard.string(forKey: StringConstants.verificationToken) {
            self.loadHome()
        } else {
            self.loadRegistration()
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    func loadRegistration() {
        let navigation = UINavigationController()
        let registrationCoordinator = RegistrationCoordinator.init(navigationController: navigation)
        registrationCoordinator.start()
        window?.rootViewController = navigation
    }
    
    private func loadHome() {
        let navigation = UINavigationController()
        let homeCoordinator = BaseTabbarCoordinator.init(navigationController: navigation)
        window?.rootViewController = homeCoordinator.getMainView()
    }

   

}

