//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/2/23.
//

import MapKit
import CloudKit

extension LocationMapView {

    final class LocationMapViewModel: ObservableObject {
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var alertItem: AlertItem?
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        func getLocations(for locationManager: LocationManager) {
            CloudKitManager.shared.getLocations { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locations):
                        locationManager.locations = locations
                    case .failure(_):
                        self.alertItem = AlertContext.unableToGetLocations
                    }
                }
            }
        }
        
        func getCheckedInCount() {
            CloudKitManager.shared.getCheckedInProfilesCount { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let checkedInProfiles):
                        self.checkedInProfiles = checkedInProfiles
                    case .failure(_):
                        self.alertItem = AlertContext.checkedInCount
                    }
                }
            }
        }
    }
}


