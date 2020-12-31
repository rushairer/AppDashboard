//
//  AppDelegate.swift
//  Dashboard (iOS)
//
//  Created by Abenx on 2020/12/26.
//

import SwiftUI
import CoreData
import UserNotifications
import UserNotificationsUI
import ABCloudKitPublicDatabaseSyncEngine

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var cloudNotification: ABCloudNotification = ABCloudNotification()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.registerForRemoteNotifications()
        
        application.applicationIconBadgeNumber = 0
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            
        }
       
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        
        return false
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        center.removeAllDeliveredNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PersistencePublicController.shared.records.forEach({ record in
            record.processSubscriptionNotification(with: userInfo)
        })
        
        completionHandler(.newData)
    }
}

