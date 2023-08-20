//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/2/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    //MARK: - MapView Errors
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"),
                                                message: Text("Unable to retrieve locations at this time.\nPlease try again."),
                                                dismissButton: .default(Text("OK")))
    
    static let locationRestricted = AlertItem(title: Text("Location Restricted"),
                                              message: Text("Your location is restricted. This may be due to parental controls."),
                                              dismissButton: .default(Text("OK")))
    
    static let locationDenied = AlertItem(title: Text("Location Denied"),
                                          message: Text("Dub Dub Grub does not have permission to access your location. Allow access to continue."),
                                          dismissButton: .default(Text("OK")))
    
    static let locationDisabled = AlertItem(title: Text("Location Disabled"),
                                            message: Text("Your phone's location services are disabled. Turn on location services to continue."),
                                            dismissButton: .default(Text("OK")))
    
    //MARK: - Profile Errors
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"),
                                          message: Text("All fields are required as well as a profile photo. Your bio must be < 100 characters.\nPlease try again."),
                                          dismissButton: .default(Text("OK")))
    
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                        message: Text("You must log into your iCloud account on your phone in order to utilize Dub Dub Grub's Profile."),
                                        dismissButton: .default(Text("OK")))
    
    static let createProfileSuccess = AlertItem(title: Text("Profile Created Successfully"),
                                                message: Text("Your profile has been successfully created."),
                                                dismissButton: .default(Text("OK")))
    
    static let createProfileFailure = AlertItem(title: Text("Failed to Create Profile"),
                                                message: Text("We were unable to create your profile at this time.\nPlease try again later or contact customer support if this persists."),
                                                dismissButton: .default(Text("OK")))
    
    static let unableToFetchProfile = AlertItem(title: Text("Unable to Retrieve Profile"),
                                                message: Text("We were unable to retrieve your profile at this time.\nPlease try again later or contact customer support if this persists."),
                                                dismissButton: .default(Text("OK")))
    
    static let updateProfileSuccess = AlertItem(title: Text("Profile Update Success!"),
                                                message: Text("Your Dub Dub Grub's profile has been updated."),
                                                dismissButton: .default(Text("OK")))
    
    static let updateProfileFailure = AlertItem(title: Text("Profile Update Failed"),
                                                message: Text("We were unable to update your profile at this time.\nPlease try again later or contact customer support if this persists."),
                                                dismissButton: .default(Text("OK")))
    
    //MARK: - LocationDetailView Errors
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"),
                                              message: Text("The phone number for the location is invalid.\nPlease try again."),
                                              dismissButton: .default(Text("OK")))
    
    static let unableToGetCheckedInStatus = AlertItem(title: Text("Server Error"),
                                                      message: Text("Unable to retrieve checked in status of the current user.\nPlease try again."),
                                                      dismissButton: .default(Text("OK")))
    
    static let unableToCheckInOrOut = AlertItem(title: Text("Server Error"),
                                                message: Text("We are unable to check in/out at this time.\nPlease try again."),
                                                dismissButton: .default(Text("OK")))
    
    static let unableToGetCheckedInProfiles = AlertItem(title: Text("Server Error"),
                                                message: Text("We are unable to get users checked into this location at this time.\nPlease try again."),
                                                dismissButton: .default(Text("OK")))
}
