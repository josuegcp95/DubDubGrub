//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/22/23.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
    }
    
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem {Label("Map", systemImage: "map")}
            
            LocationListView()
                .tabItem {Label("Locations", systemImage: "building")}
            
            NavigationView {ProfileView()}
            .tabItem {Label("Profile", systemImage: "person")}

        }
        .task {
            try? await CloudKitManager.shared.getUserRecord()
            viewModel.runStartupChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardView, onDismiss:  viewModel.checkIfLocationServicesIsEnabled) {
            OnBoardView()
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}

