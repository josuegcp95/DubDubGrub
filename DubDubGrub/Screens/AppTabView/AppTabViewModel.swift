//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 8/19/23.
//

import SwiftUI
import CoreLocation

extension AppTabView {
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var isShowingOnboardView = false
        @Published var alertItem: AlertItem?
        
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView  }
        }
        
        var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func runStartupChecks() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkIfLocationServicesIsEnabled()
            }
        }
        
        func checkIfLocationServicesIsEnabled() {
            DispatchQueue.global().async { [self] in
                if CLLocationManager.locationServicesEnabled() {
                   deviceLocationManager = CLLocationManager()
                    deviceLocationManager?.delegate = self
                } else {
                    self.alertItem = AlertContext.locationDisabled
                }
            }
        }
        
        private func checkLocationAuthorization() {
            guard let deviceLocationManager = deviceLocationManager else { return }
            switch deviceLocationManager.authorizationStatus {
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                self.alertItem = AlertContext.locationRestricted
            case .denied:
                self.alertItem = AlertContext.locationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
    }
}


