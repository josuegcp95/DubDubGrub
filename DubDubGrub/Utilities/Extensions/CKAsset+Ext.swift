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
        guard let fileUrl = self.fileURL else { return dimension.placeHolder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.placeHolder
        } catch {
            return dimension.placeHolder
        }
    }
}

