//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 8/7/23.
//

import CloudKit

@MainActor
final class LocationListViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    @Published var alertItem: AlertItem?
    
    func getCheckedInProfilesDictionary() {
        Task {
            do {
                checkedInProfiles =  try await CloudKitManager.shared.getCheckedInProfilesDictionary()
            } catch {
                alertItem = AlertContext.unableToGetAllCheckedInProfiles
                
            }
        }
    }
    
    func createVoiceOverSummary(for location: DDGLocation) -> String {
        let count = checkedInProfiles[location.id, default: []].count
        let personPlurality = count == 1 ? "person" : "people"
        return "\(location.name) \(count) \(personPlurality) checked in"
    }
}
