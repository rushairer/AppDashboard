//
//  CloudKitService.swift
//  Dashboard
//
//  Created by Abenx on 2020/12/26.
//

import Foundation
import CoreData


final class CloudKitService: ObservableObject {
    @Published var userName: String = ""
    @Published var projects: [CKRecord] = []
    @Published var didNotificationCreated: Bool = false
    
    private(set) lazy var container: CKContainer = {
        CKContainer.default()
    }()
    
    private(set) lazy var zoneID: CKRecordZone.ID = {
        CKRecordZone.default().zoneID
    }()
    
    
    func cloudOperationQueue(container: String, recordType: String)-> OperationQueue {
        let underlyingQueue = DispatchQueue(label: "\(container).\(recordType).queue.cloud", qos: .userInitiated)
        let queue = OperationQueue()
        queue.underlyingQueue = { [unowned underlyingQueue] in
            return underlyingQueue
        }()
        queue.name = "\(container).\(recordType).operationqueue.cloud"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    init() {
        
    }
    
    func inactive() {
        userName = ""
        projects = []
        didNotificationCreated = false
    }
    
    func active() {
        self.requestUserInfo { [weak self] userName in
            guard let self = self else { return }
            self.userName = userName
            self.fetchAllProjects()
        }
    }
    
    func requestUserInfo(completionHandler: ((_ userName: String) -> Void)?) {
        self.container.accountStatus { status, error in
            
            guard status == .available else {
                self.inactive()
                return
            }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                if status == .granted {
                    CKContainer.default().fetchUserRecordID { (recordID, error) in
                        if let error = error {
                            print(error)
                        } else {
                            CKContainer.default().discoverUserIdentity(withUserRecordID: recordID!) { (user, error) in
                                if let user = user {
                                    let userName = PersonNameComponentsFormatter().string(from: user.nameComponents!)
                                    DispatchQueue.main.sync {
                                        if let completionHandler = completionHandler {
                                            completionHandler(userName)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchAllProjects() {
        let recordType = "Projects"
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let operation = CKQueryOperation(query: query)
        operation.database = self.container.publicCloudDatabase
        operation.qualityOfService = .userInitiated
        operation.resultsLimit = CKQueryOperation.maximumResults
        
        operation.recordFetchedBlock = { [weak self] record in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.projects.append(record)
            }
        }
        
        self.cloudOperationQueue(container: self.container.containerIdentifier!.description, recordType: recordType).addOperation(operation)
    }
    
    func createNotification(containerName: String, title: String, content: String, info: String) {
        let recordType = "CloudNotification_zh"
        
        let container = CKContainer(identifier: containerName)
        
        let record: CKRecord = CKRecord(recordType: recordType)
        record.setValue(title, forKey: "title")
        record.setValue(content, forKey: "content")
        record.setValue(info, forKey: "info")
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.database = container.publicCloudDatabase
        operation.qualityOfService = .userInitiated
        
        operation.modifyRecordsCompletionBlock = { [weak self] _, _, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.didNotificationCreated = true
                }
            }
        }
        
        self.didNotificationCreated = false
        self.cloudOperationQueue(container: containerName, recordType: recordType).addOperation(operation)
    }
}
