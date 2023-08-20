//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/25/23.
//

import SwiftUI

extension View {
    
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
