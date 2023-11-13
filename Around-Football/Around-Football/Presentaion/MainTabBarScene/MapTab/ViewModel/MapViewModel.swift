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
    
    func setSearchLocation(_ keyword: String) {
        // searchLocation = GeoPoint(latitude: latitude, longitude: longitude)
//        guard let apiUrl = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json") else {
//            return
//        }
//        
        guard let apiUrl = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            return
        }
        
        let apiKey = "07874a02a8d48af697b51048893c3d70"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]

        // RxAlamofire를 사용한 비동기 요청
        RxAlamofire
            .data(.get, apiUrl, headers: headers)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(KakaoPlaceResponse.self, from: data)
                    
                    if let firstPlace = result.documents.first {
                        // 검색된 장소 중 첫 번째 장소의 좌표로 이동
//                        self?.moveToLocation(latitude: firstPlace.y, longitude: firstPlace.x)
                        self?.searchLocation = GeoPoint(latitude: Double(firstPlace.y) ?? 0.0, longitude: Double(firstPlace.x) ?? 0.0)
                    } else {
                        print("장소를 찾을 수 없습니다.")
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
