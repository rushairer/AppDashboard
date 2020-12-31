//
//  Persistence.swift
//  Shared
//
//  Created by Abenx on 2020/12/25.
//

import CoreData
import ABCloudKitPublicDatabaseSyncEngine

struct PersistencePublicController {
    static let shared = PersistencePublicController()
    
    let container: NSPersistentContainer
    
    var records: [ABCloudKitPublicDatabaseAutoSyncRecord] = []

    init() {
        container = NSPersistentContainer(name: "Dashboard")
        
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.managedObjectModel.entities.forEach { entity in
            let record = ABCloudKitPublicDatabaseAutoSyncRecord(with: container.viewContext, entity: entity)
            records.append(record)
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
