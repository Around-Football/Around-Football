//
//  APIService.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import Foundation
import RxSwift

let MOCKUP_URL = "https://mocki.io/v1/8f5cd61d-36f3-430a-9013-2f130ffb9cf8"

class APIService {
    
    static func fetchRecruitRx() -> Observable<Data> {
        return Observable.create { emitter in
            fetchRecruit() { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    static func fetchRecruit(onComplete: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: MOCKUP_URL)!) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
        }.resume()
    }
}
