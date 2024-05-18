//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/19/23.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkIn, checkOut }

class LocationDetailViewModel: ObservableObject {
    
    @Published var checkedInProfiles = [DDGProfile]()
    @Published var isShowingProfileModal = false
    @Published var isCheckedIn = false
    @Published var isLoading = false 
    @Published var alertItem: AlertItem?

    var location: DDGLocation
    
    var selectedProfile: DDGProfile? {
        didSet {
            isShowingProfileModal = true 
        }
    }
    
    init(location: DDGLocation) {
        self.location = location
    }
    
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
            
        }
        UIApplication.shared.open(url)
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.sync {
                switch result {
                case .success(let record):
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id
                    } else {
                        isCheckedIn = false
                    }
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckedInStatus
                }
            }
        }
    }
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToFetchProfile
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                switch checkInStatus {
                case .checkIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = 1
                case .checkOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil 
                }
                
                CloudKitManager.shared.save(record: record) { [self] result in
                    DispatchQueue.main.sync {
                        switch result {
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            switch checkInStatus {
                            case .checkIn:
                                checkedInProfiles.append(profile)
                            case .checkOut:
                                checkedInProfiles.removeAll(where: { $0.id == profile.id })
                            }
                            isCheckedIn = checkInStatus == .checkIn
                        case .failure(_):
                            alertItem = AlertContext.unableToCheckInOrOut
                        }
                    }
                }
            case .failure(_):
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                }
                hideLoadingView()
            }
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
