//
//  AppDelegate.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 27/6/24.
//

import UIKit
import FirebaseCore


var authManager:AuthManager?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        authManager = .init()
        NotificationService.shared.center.delegate = self
        NotificationService.shared.setupAppNotifications(unNotificationDelegate: self)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK: UNUserNotificationCenter Delegate Methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        if #available(iOS 14.0, *) {
            return [.banner, .badge, .sound]
        } else {
            return [.alert, .badge, .sound]
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let infoKey = response.notification.request.content.userInfo as? [String:Any] {
            print(infoKey)
        }
    }
}
