//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/23/24.
//

import UIKit

struct HapticManager {
    
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
