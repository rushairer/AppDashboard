//
//  View+Extension.swift
//  Dashboard
//
//  Created by Abenx on 2020/12/27.
//

import SwiftUI

extension View {
    @ViewBuilder func paddingForMac() -> some View {
        #if os(macOS)
        self.padding()
        #else
        self
        #endif
    }
}
