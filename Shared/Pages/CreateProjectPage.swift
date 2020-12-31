//
//  CreateProjectPage.swift
//  Dashboard
//
//  Created by Abenx on 2020/12/25.
//

import SwiftUI

struct CreateProjectPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var bundle: String = ""
    @State private var name: String = ""
    
    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Close").fontWeight(.regular)
        }
    }
    
    #if os(macOS)
    var body: some View {
        Form {
            Section(header: Text("Create Project")){
                TextField("Bundle", text: $bundle)
                TextField("Name", text: $name)
            }
        }
        .frame(minWidth: 300, minHeight: 100)
        .padding(.horizontal, 40)
        .toolbar{
            ToolbarItem(id: "CloseButton", placement: .cancellationAction) {
                closeButton
            }
        }
    }
    #else
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create Project")) {
                    TextField("Bundle", text: $bundle)
                    TextField("Name", text: $name)
                    HStack {
                        Spacer()
                        Button("Create") {
                        }
                    }
                }
            }
            .navigationTitle("Create Project")
            .padding()
            .toolbar{
                ToolbarItem(id: "CloseButton", placement: .navigationBarTrailing) {
                    closeButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    #endif
    
    
}

struct CreateProjectPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectPage()
    }
}
