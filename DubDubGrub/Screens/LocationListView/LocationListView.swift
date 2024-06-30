//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/22/23.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.locations) { location in
                    
//                    NavigationLink(value: location) {
//                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
//                            .accessibilityElement(children: .ignore)
//                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
//                    }
                    
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                    }
                    
                }
            }

            .navigationTitle("Grub Spots")
            
//            .navigationDestination(for: DDGLocation.self, destination: { location in
//                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
//            })
            
            .listStyle(.plain)
            .task { viewModel.getCheckedInProfilesDictionary() }
            .refreshable { viewModel.getCheckedInProfilesDictionary() }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
