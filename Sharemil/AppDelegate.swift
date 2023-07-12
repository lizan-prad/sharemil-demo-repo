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
import StripeApplePay
import Mixpanel
import OneSignal
//Onesignal app id - 5abbae8b-137a-444c-8977-1e61fd5cdf1f
//Onesignal prod app id - 25e41f3e-d9ad-4107-a042-f2cff3bcd6eb
let db = Firestore.firestore()

var order_id: String?

let appdelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate, OSSubscriptionObserver {
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        if !stateChanges.from.isSubscribed && stateChanges.to.isSubscribed {
             print("Subscribed for OneSignal push notifications!")
          }
          print("SubscriptionStateChange: \n\(stateChanges)")

          //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            let url = "push-notifications/token"
            let param: [String: Any] = ["token": playerId]
            NetworkManager.shared.request(HoursModel.self, urlExt: url, method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            }
        }
    }
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        StripeAPI.defaultPublishableKey = UserDefaults.standard.string(forKey: "ENV") == "D" ? "pk_test_51KgHBhEYsFc3t3viMQOBYoGfyFWgPIruKiWjSIO7IKqU0GREnosyUh3HeGw0hxc7lAQ3emeODmvUUjiRUXHvDZ5U00egomEJjd" : "pk_live_51KgHBhEYsFc3t3vi6dtj1unr25ctwTJkY9Ua5r3WHk2J89Ign01VESp7y10ueKtd87kPEoPwXc1xF4jDqh3PQxsy00ZSHHjRxx"
        IQKeyboardManager.shared().isEnabled = true
        Mixpanel.initialize(token: "0e14a883d35c0890cd38ef768ea7d10c", trackAutomaticEvents: true)
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
//        Messaging.messaging().delegate = self
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
          
          // OneSignal initialization
          OneSignal.initWithLaunchOptions(launchOptions)
        if UserDefaults.standard.string(forKey: "ENV") == nil {
            UserDefaults.standard.set("D", forKey: "ENV")
        }
        OneSignal.add(self)
        OneSignal.setAppId(UserDefaults.standard.string(forKey: "ENV") == "D" ? "5abbae8b-137a-444c-8977-1e61fd5cdf1f" : "25e41f3e-d9ad-4107-a042-f2cff3bcd6eb")
          
          // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
          OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
          })
        return true
    }
    
    
    private func loadHome() {
        let navigation = UINavigationController()
        let homeCoordinator = BaseTabbarCoordinator.init(navigationController: navigation)
        appdelegate.window?.rootViewController = homeCoordinator.getMainView()
    }
    
    
    func loadRegistration() {
        let navigation = UINavigationController()
        let registrationCoordinator = RegistrationCoordinator.init(navigationController: navigation)
        registrationCoordinator.start()
        appdelegate.window?.rootViewController = navigation
    }
    
    func registerNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                
            }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("enter")
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        switch UIApplication.shared.applicationState {
        case .active:
            //            print("active")
            
            completionHandler([.sound, .alert, .badge])
            
        default:
            completionHandler([.alert, .sound, .badge])
            
        }
   
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        let info = response.notification.request.content.userInfo as? [String: Any]
        let type = info?["type"] as? String
        let id = info?["id"] as? String
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CHECK"), object: id)
        order_id = id
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
//        Messaging.messaging().apnsToken = deviceToken
    }
   
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//      print("Firebase registration token: \(String(describing: fcmToken))")
//        let param: [String: Any] = [
//            "token": fcmToken ?? ""
//        ]
//        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "push-notifications/token", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
//
//        }
////        UserDefaults.standard.set(fcmToken ?? "", forKey: StringConstants.userIDToken)
////      let dataDict: [String: String] = ["token": fcmToken ?? ""]
////      NotificationCenter.default.post(
////        name: Notification.Name("FCMToken"),
////        object: nil,
////        userInfo: dataDict
////      )
//      // TODO: If necessary send token to application server.
//      // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
}

