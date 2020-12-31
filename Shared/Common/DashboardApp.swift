//
//  DashboardApp.swift
//  Shared
//
//  Created by Abenx on 2020/12/25.
//

import SwiftUI

@main
struct DashboardApp: App {
    @Environment(\.scenePhase) private var scenePhase

    #if os(macOS)
        @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    
    #if os(iOS)
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    
    let persistenceController = PersistencePublicController.shared
    
    let cloudKitService: CloudKitService = {
        let cloudKitService: CloudKitService = CloudKitService()
        cloudKitService.active()
        return cloudKitService
    }()
     
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cloudKitService)
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                changedToBackground()
            case .inactive:
                changedToInactive()
            case .active:
                changedToActive()
            @unknown default:
                break
            }
        }
    }
    
    func changedToBackground() {
        
    }
    
    func changedToInactive() {
    }
    
    func changedToActive() {
    }
}
