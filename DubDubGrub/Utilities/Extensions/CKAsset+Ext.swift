//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/3/23.
//

import CloudKit
import UIKit

extension CKAsset {
    
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeholder = ImageDimension.getPlaceHolder(for: dimension)
        
        guard let fileUrl = self.fileURL else { return placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}

