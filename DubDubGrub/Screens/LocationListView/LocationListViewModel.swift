//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 8/7/23.
//

import CloudKit

final class LocationListViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    @Published var alertItem: AlertItem?
    
    func getCheckedInProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    self.alertItem = AlertContext.unableToGetAllCheckedInProfiles
                }
            }
        }
    }
    
    func createVoiceOverSummary(for location: DDGLocation) -> String {
        let count = checkedInProfiles[location.id, default: []].count
        let personPlurality = count == 1 ? "person" : "people"
        return "\(location.name) \(count) \(personPlurality) checked in"
    }
}
