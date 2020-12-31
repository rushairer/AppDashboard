//
//  AppDelegate.swift
//  Dashboard (macOS)
//
//  Created by Abenx on 2020/12/25.
//

import SwiftUI
import UserNotifications
import UserNotificationsUI
import ABCloudKitPublicDatabaseSyncEngine

class AppDelegate: NSResponder, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    var cloudNotification: MacCloudNotification = MacCloudNotification()

    var statusBarItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {

        // Create the status item in the Menu bar
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        // Add a menu and a menu item
//        let menu = NSMenu()
//        let editMenuItem = NSMenuItem()
//        editMenuItem.title = "Create Project"
//        editMenuItem.image = NSImage(systemSymbolName: "plus", accessibilityDescription: "")
//
//        menu.addItem(editMenuItem)

        //Set the menu
        //self.statusBarItem!.menu = menu

        //print(NSLocale.preferredLanguages.first!)
        //This is the button which appears in the Status bar
        
        let appName: String = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String

        if let button = self.statusBarItem!.button {
            button.title = appName
            button.action = #selector(showPopover(_:))
        }
        let rootView = Text("Hello").padding(100)
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 350)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: rootView)
        self.popover = popover
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            //guard authorized else { return }
            DispatchQueue.main.async {
                //NSApplication.shared.unregisterForRemoteNotifications()
                NSApplication.shared.registerForRemoteNotifications()
                let isRegistered = NSApplication.shared.isRegisteredForRemoteNotifications
                print(isRegistered)
            }
        }
        center.getNotificationSettings { setting in
            print(setting)
        }
        center.getDeliveredNotifications { notifications in
            print(notifications)
        }
        center.getPendingNotificationRequests { requests in
            print(requests)
        }
        
    }
    
    @objc func showPopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem!.button
        {
            if self.popover!.isShown {
                self.popover!.performClose(sender)
            } else {
                self.popover!.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func application(_ application: NSApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print(deviceToken)
    }
     
    func application(_ application: NSApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
    }
    
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        center.removeAllDeliveredNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        PersistencePublicController.shared.records.forEach({ record in
            record.processSubscriptionNotification(with: userInfo)
        })
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
