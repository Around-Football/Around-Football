//
//  MapViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/5/23.
//

import Foundation
import FirebaseFirestore

class MapViewModel {
    var currentLocation: GeoPoint
    var searchLocation: GeoPoint?
    var isSearchCurrentLocation: Bool = true
    
    
    init(latitude: Double, longitude: Double, searchLocation: GeoPoint? = nil) {
        self.currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
        self.searchLocation = searchLocation
    }
    
    func setCurrentLocation(latitude: Double, longitude: Double) {
        currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
    }
    
    func setSearchLocation(latitude: Double, longitude: Double) {
        searchLocation = GeoPoint(latitude: latitude, longitude: longitude)
    }
}
