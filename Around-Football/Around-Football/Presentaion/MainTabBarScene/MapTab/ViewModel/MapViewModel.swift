//
//  MapViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/5/23.
//

import Foundation

import Alamofire
import FirebaseFirestore
import RxAlamofire
import RxSwift

final class MapViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: MapTabCoordinator?
    
    let searchResults = BehaviorSubject<[Place]>(value: [])
    var dataSubject: PublishSubject = PublishSubject<Place>()
    
    var currentLocation: GeoPoint
    var searchLocation: GeoPoint?
    var isSearchCurrentLocation: Bool = true
    private let disposeBag = DisposeBag()
    private let firebaseAPI = FirebaseAPI.shared
    var fields: [Field] = []
    var selectedDate: Date = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy / MM / dd"
            print(formatter.string(from: selectedDate))
        }
    }
    
    // MARK: - Lifecycles
    
    init(latitude: Double, longitude: Double, searchLocation: GeoPoint? = nil) {
        self.currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
        self.searchLocation = searchLocation
        selectedDate = Date()
    }
    
    // MARK: - API
    
    func fetchFields() {
        firebaseAPI.fetchMockFieldsData { fields in
            self.fields = fields
        }
    }
    
    // MARK: - Helpers
    
    func setCurrentLocation(latitude: Double, longitude: Double) {
        currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
    }
}
