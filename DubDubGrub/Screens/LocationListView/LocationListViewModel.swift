//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 8/7/23.
//

import CloudKit

final class LocationListViewModel: ObservableObject {
 
    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    
    func getCheckedInProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                    print(checkedInProfiles)
                case .failure(_):
                    print("Error getting back dictionary ")
                }
            }
        }
    }
}
