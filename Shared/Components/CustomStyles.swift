//
//  CustomStyles.swift
//  Dashboard
//
//  Created by Abenx on 2020/12/25.
//

import SwiftUI

struct ABButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color.accentColor
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .listRowBackground(configuration.isPressed ? backgroundColor.opacity(0.5) : backgroundColor)
    }
}


struct CustomStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            List {
                Button("Logout") {
                    
                }.buttonStyle(ABButtonStyle())
                
                Button("Logout") {
                    
                }.buttonStyle(ABButtonStyle(backgroundColor: .red))
            }
        }
    }
}
