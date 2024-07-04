//
//  NotificationService.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 4/7/24.
//

import Foundation
import UserNotifications

final class NotificationService {
    static var shared = NotificationService()
    
    private init() {}
    
    var center = UNUserNotificationCenter.current()
    
    func setupAppNotifications(unNotificationDelegate: UNUserNotificationCenterDelegate) {
        center.delegate = unNotificationDelegate
        
        Task {
            if await !checkPermission() {
                    //TODO: Check notification settings and handle if disabled
                    //await NotificationService.shared.checkNotificationSettings()
                await requestNotificationAuthorisation()
                
            }
        }
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    func checkPermission() async -> Bool {
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
            case .notDetermined, .provisional, .ephemeral:
                return await requestNotificationAuthorisation()
                
            case .denied:
                return false
                
            case .authorized:
                return true
                
            @unknown default:
                return false
        }
    }
    
    @discardableResult func requestNotificationAuthorisation() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert])
            
            return granted
        }
        catch {
            debugPrint(error)
            return false
        }
    }
    
    func checkNotificationSettings() async {
        let settings = await center.notificationSettings()
        
        switch settings.notificationCenterSetting {
            case .enabled:
                debugPrint("Notification Settings Enabled")
                
            case .notSupported:
                debugPrint("Notification Not Supported")
                
            case .disabled:
                debugPrint("Notification Settings Disabled")
                
            @unknown default:
                break
        }
    }
    
    func sendNotification(title: String, subtitle: String? = nil, body: String, category: String, launchIn: Double = 0.5, imageName: String = "", imageURL: URL? = nil,userInfo:[String:Any]? = nil,launchDate:DateComponents? = nil,identifier:String = UUID().uuidString) {
        Task {
            if await checkPermission() {
                await sendNotification(title: title, subtitle: subtitle, body: body, category: category, launchIn: launchIn, imageName: imageName, imageURL: imageURL,userInfo: userInfo,launchDate: launchDate, identifier: identifier)
            } else {
                if await requestNotificationAuthorisation() {
                    await sendNotification(title: title, subtitle: subtitle, body: body, category: category, launchIn: launchIn, imageName: imageName, imageURL: imageURL,userInfo: userInfo,launchDate: launchDate, identifier: identifier)
                }
            }
        }
    }
    
    private func sendNotification(title: String, subtitle: String?, body: String, category: String, launchIn: Double, imageName: String, imageURL: URL?,userInfo:[String:Any]? = nil,launchDate:DateComponents? = nil,identifier:String) async {
        
        let content = UNMutableNotificationContent()
        content.title = title
        
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        
        content.body = body
        content.categoryIdentifier = category
        content.sound = UNNotificationSound.default
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        if let url = imageURL, !imageName.isEmpty {
            do {
                let attachment = try UNNotificationAttachment(identifier: imageName, url: url)
                content.attachments = [attachment]
            }
            catch {
                debugPrint(error)
            }
        }
        
        let trigger = (launchDate == nil) ? UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false) : UNCalendarNotificationTrigger(dateMatching: launchDate!, repeats: false)
        
        print(identifier)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        do {
            try await center.add(request)
        }
        catch {
            debugPrint(error)
        }
    }
    
    func checkIfNotificaionAlreadyExists(identifier:String,completion: @escaping (Bool) -> Void){
        center.getPendingNotificationRequests { requests in
            for request in requests where request.identifier == identifier{
                completion(true)
                return
            }
            completion(false)
        }
    }
}
