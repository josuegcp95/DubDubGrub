//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/22/23.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPointMake(0.5, 0.75)) {
                    DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .accentColor(.brandSecondary)
            .ignoresSafeArea()
            
            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                Spacer()
            }
        }
                
        .onAppear {
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
            
            viewModel.getCheckedInCount()
        }
        
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView {
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar {
                        Button("Dismiss", action: {viewModel.isShowingDetailView = false})
                    }
            }
            .accentColor(.brandPrimary)
        }
        
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
