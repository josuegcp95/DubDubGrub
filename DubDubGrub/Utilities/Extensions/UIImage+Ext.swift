//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/9/23.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        // Get document directory url path
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // Append unique identifier to url path
        let fileUrl = urlPath.appending(path: "selectedAvatarImage")
        
        // Create image data container
        guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }
        
        // Create CKAsset with fileURL
        do {
            try  imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
}
