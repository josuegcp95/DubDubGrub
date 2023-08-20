//
//  Constants.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/2/23.
//

import UIKit

enum RecordType {
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum PlaceHolderImage {
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimension {
    case square, banner
    
    static func getPlaceHolder(for dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            return PlaceHolderImage.square
        case .banner:
            return PlaceHolderImage.banner
        }
    }
}
