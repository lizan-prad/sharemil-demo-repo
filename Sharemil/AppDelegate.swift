//
//  AppDelegate.swift
//  Sharemil
//
//  Created by Lizan on 08/06/2022.
//

import UIKit
import IQKeyboardManager
import FirebaseCore
import GoogleMaps
import GooglePlaces
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore
import Alamofire

let db = Firestore.firestore()

let appdelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyBlypJ0XqI0gRXSMz0nlvGRCKN5R_pNNO4")
        GMSPlacesClient.provideAPIKey("AIzaSyBlypJ0XqI0gRXSMz0nlvGRCKN5R_pNNO4")
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        if let _ = UserDefaults.standard.string(forKey: StringConstants.verificationToken) {
            self.loadHome()
        } else {
            self.loadRegistration()
        }
        window?.makeKeyAndVisible()
        registerNotification(application)
        Messaging.messaging().delegate = self
        return true
    }
    
    func registerNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (status, error) in
                if status {
                        print("Permission granted. Scheduling notification")
                    }
            }
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func loadRegistration() {
        let navigation = UINavigationController()
        let registrationCoordinator = RegistrationCoordinator.init(navigationController: navigation)
        registrationCoordinator.start()
        window?.rootViewController = navigation
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("enter")
    }
    
    private func loadHome() {
        let navigation = UINavigationController()
        let homeCoordinator = BaseTabbarCoordinator.init(navigationController: navigation)
        window?.rootViewController = homeCoordinator.getMainView()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .sound, .badge])
   
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
       // Get the meeting ID from the original notification.
       completionHandler()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            let userInfo = notification.request.content.userInfo
//            // Print message ID.
//            print("Message ID: \(userInfo["gcm.message_id"]!)")
//
//            // Print full message.
//            print("%@", userInfo)
//
//        }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        let param: [String: Any] = [
            "token": fcmToken ?? ""
        ]
        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "push-notifications/token", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            
        }
//        UserDefaults.standard.set(fcmToken ?? "", forKey: StringConstants.userIDToken)
//      let dataDict: [String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

