//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/22/23.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
    
    var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
