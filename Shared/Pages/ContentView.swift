//
//  ContentView.swift
//  Shared
//
//  Created by Abenx on 2020/12/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var cloudKitService: CloudKitService;
            
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cloudKitService.projects, id: \.self) { project in
                        NavigationLink(destination: CloudNotificationPage(name: project["name"] as! String, bundle: project["bundle"] as! String)) {
                            Text(project["name"] as! String)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .toolbar {
                    #if os(macOS)
                    ToolbarItem(id: "ToggleSidebar", placement: .navigation) {
                        Button(action: toggleSidebar) {
                            Label("Toggle Sidebar", systemImage: "sidebar.left")
                        }
                    }
                    #else
                    #endif
                }
                .navigationTitle("Projects")
                Spacer()
                
                #if DEBUG
                Text("Development")
                    .foregroundColor(.green)
                    .padding()
                #else
                Text("Production")
                    .foregroundColor(.pink)
                    .padding()

                #endif
            }
            VStack {
                if cloudKitService.userName.count > 0 {
                    Text("Welcome, \(cloudKitService.userName)!")

                } else {
                    Text("Need sign in with your iCloud account.")
                    Button(action: {
                        CKFetchWebAuthTokenOperation.init().fetchWebAuthTokenCompletionBlock = { token, error in
                            print(token as Any)
                        }
                    }, label: {
                        Text("Sign in with iCloud account")
                    })
                }
            }
            
        }
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistencePublicController.shared.container.viewContext)
            .environmentObject(CloudKitService())
    }
}
