//
//  KakaoService.swift
//  Around-Football
//
//  Created by 강창현 on 11/16/23.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

// TODO: - APIService 타입명 변경
final class KakaoService {
    static let shared = KakaoService()
    
    private init() { }
    
    func fetchKakaoSearch(_ keyword: String) -> Observable<[Place]> {
        
        guard 
            let apiUrl = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        else {
            return Observable.empty()
        }
        
        let apiKey = "07874a02a8d48af697b51048893c3d70"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]
        
        return RxAlamofire
            .data(.get, apiUrl, headers: headers)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { data in
                return try JSONDecoder().decode(KakaoPlaceResponse.self, from: data)
            }
            .map { response in
                response.documents.map { placeData in
                    Place(id: placeData.id, name: placeData.placeName, address: placeData.addressName, x: placeData.x, y: placeData.y)
                }
            }
    }
}
