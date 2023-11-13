//
//  SearchViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 11/13/23.
//

import Foundation

import Alamofire
import FirebaseFirestore
import RxAlamofire
import RxSwift

class SearchViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var searchPlaces: [Place] = []
    
    // MARK: - Helpers
    
    func searchField(_ keyword: String) {
        
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
                    
                    self?.searchPlaces = result.documents.map {
                        Place(id: $0.id, name: $0.placeName, address: $0.addressName, x: $0.x, y: $0.y)
                    }
                    print(self?.searchPlaces ?? "파싱 에러")
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
