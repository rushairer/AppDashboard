//
//  CloudNotificationPage.swift
//  Dashboard
//
//  Created by Abenx on 2020/12/27.
//

import SwiftUI
import ABSwiftKitExtension

struct CloudNotificationPage: View {
    @EnvironmentObject var cloudKitService: CloudKitService;
    
    @State var name: String
    @State var bundle: String
    @State var msgTitle: String = ""
    @State var msgContent: String = ""
    @State var msgInfo: String = "{}"
    
    @State var showsSendAlert: Bool = false
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Send Notification")) {
                    TextField("Title", text: $msgTitle)
                    TextEditor(text: $msgContent)
                        .lineLimit(30)
                        .frame(minHeight: 200)
                    TextField("Info", text: $msgInfo)
                    HStack {
                        Spacer()
                            .alert(isPresented: $cloudKitService.didNotificationCreated, content: didNotificationCreatedAlert)
                        
                        Button("Send") {
                            showsSendAlert = true
                        }
                        .alert(isPresented: $showsSendAlert, content: alertView)
                    }
                }
            }
            .paddingForMac()
            Spacer()
        }
        .navigationTitle(name)
    }
    
    func alertView() -> Alert {
        let send = Alert.Button.default(Text("Send")) {
            cloudKitService.createNotification(containerName: "iCloud.\(bundle)", title: msgTitle, content: msgContent, info: msgInfo)
        }
        let cancel = Alert.Button.cancel(Text("Cancel")) {  }
        return Alert(title: Text(msgTitle), message: Text(msgContent), primaryButton: send, secondaryButton: cancel)
    }
    
    func didNotificationCreatedAlert() -> Alert {
        Alert(title: Text("Notification has been sent successfully"), message: Text(msgTitle), dismissButton: Alert.Button.default(Text("OK")))
    }
    
}

struct CloudNotificationPage_Previews: PreviewProvider {
    static var previews: some View {
        CloudNotificationPage(name: "Project Name", bundle: "bundle name")
            .environment(\.managedObjectContext, PersistencePublicController.shared.container.viewContext)
            .environmentObject(CloudKitService())
    }
}
