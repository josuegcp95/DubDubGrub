//
//  MockData.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/2/23.
//

import CloudKit

struct MockData {
    
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Sean's Bar and Grill"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test description. This is a test description. This is a test description."
        record[DDGLocation.kWebsiteURL] = "https://seanallen.co"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "937-356-7725"
        return record
    }
    
    static var profile: CKRecord {
        let record = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName] = "Test"
        record[DDGProfile.kLastName] = "User"
        record[DDGProfile.kCompanyName] = "BCE"
        record[DDGProfile.kBio] = "This is my bio. This is my bio. This is my bio. More about me here. More about me here. More about me here."
        return record
    }
}
