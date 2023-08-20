//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/2/23.
//

import Foundation

final class LocationManager: ObservableObject {
    
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
