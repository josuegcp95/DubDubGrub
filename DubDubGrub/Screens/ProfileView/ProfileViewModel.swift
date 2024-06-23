//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/11/23.
//

import CloudKit

enum ProfileContext { case create, update }

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var companyName = ""
    @Published var bio = ""
    @Published var avatar = PlaceHolderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isLoading = true
    @Published var isCheckedIn = false
    @Published var alertItem: AlertItem?
    
    private var existingProfileRecord: CKRecord? {
        didSet { profileContext = .update }
    }
    var profileContext: ProfileContext = .create
    
    func isValidProfile() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceHolderImage.avatar,
              bio.count < 100 else { return false }
        return true
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                    isCheckedIn = true
                } else {
                    isCheckedIn = false
                }
            } catch {
                print("Unable to get checked in status")
            }
        }
    }
    
    func checkOut() {
        guard let profileID = CloudKitManager.shared.profileRecordID else { alertItem = AlertContext.unableToFetchProfile; return }
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                record[DDGProfile.kIsCheckedIn] = nil
                record[DDGProfile.kIsCheckedInNilCheck] = nil

                let _ = try await CloudKitManager.shared.save(record: record)
                HapticManager.playSuccess()
                isCheckedIn = false
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    func createProfile() {
        guard isValidProfile() else { alertItem = AlertContext.invalidProfile; return }
        let profileRecord = createProfileRecord()
        guard let userRecord = CloudKitManager.shared.userRecord else { alertItem = AlertContext.noUserRecord; return }
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        
        Task {
            do {
                let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                for record in records where record.recordType == RecordType.profile {
                    existingProfileRecord = record
                    CloudKitManager.shared.profileRecordID = record.recordID
                }
                hideLoadingView()
                alertItem = AlertContext.createProfileSuccess
            } catch {
                hideLoadingView()
                alertItem = AlertContext.createProfileFailure
            }
        }
    }
    
    func getProfile() {
        guard let userRecord = CloudKitManager.shared.userRecord else { alertItem = AlertContext.noUserRecord; return }
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        let profileRecordID = profileReference.recordID
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                existingProfileRecord = record
                let profile = DDGProfile(record: record)
                firstName = profile.firstName
                lastName = profile.lastName
                companyName = profile.companyName
                bio = profile.bio
                avatar = profile.avatarImage
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToFetchProfile
            }
        }
    }
    
    func updateProfile() {
        guard isValidProfile() else { alertItem = AlertContext.invalidProfile; return }
        guard let profileRecord = existingProfileRecord else { alertItem = AlertContext.unableToFetchProfile; return }
        
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        
        showLoadingView()
        
        Task {
            do {
                let _ = try await CloudKitManager.shared.save(record: profileRecord)
                hideLoadingView()
                alertItem = AlertContext.updateProfileSuccess
            } catch {
                hideLoadingView()
                alertItem = AlertContext.updateProfileFailure
            }
        }
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        return profileRecord
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
