//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 8/19/23.
//

import Foundation
import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject {
    
    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?
    
    var deviceLocationManager: CLLocationManager?
    let kHasSeenOnboardView = "hasSeenOnboardView"
    
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
    }
    
    func runStartupChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
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
}

extension AppTabViewModel:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
