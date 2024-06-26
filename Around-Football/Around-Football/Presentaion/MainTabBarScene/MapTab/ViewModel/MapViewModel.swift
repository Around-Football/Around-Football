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
    
    // MARK: - Lifecycles
    
    init(coordinator: MapTabCoordinator, latitude: Double, longitude: Double, searchLocation: GeoPoint? = nil) {
        self.coordinator = coordinator
        self.currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
        self.searchLocation = searchLocation
    }
    
    // MARK: - API
    
    func fetchFields(completion: @escaping ([Field]) -> Void) async throws {
        try await firebaseAPI.fetchFields { fields in
            self.fields = fields
            completion(fields)
        }
    }
    
    func presentDetailViewController(itemID: String) {
        firebaseAPI.fetchRecruitFieldData(fieldID: itemID) { [weak self] recruits in
            self?.coordinator?.presentDetailViewController(recruits: recruits)
        }
    }
    
    // MARK: - Helpers
    
    func setCurrentLocation(latitude: Double, longitude: Double) {
        currentLocation = GeoPoint(latitude: latitude, longitude: longitude)
    }
    
    func searchFields(keyword: String, disposeBag: DisposeBag) {
        KakaoService.shared.searchField(keyword, searchResults, disposeBag)
    }
}
