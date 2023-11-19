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
import RxRelay

final class SearchViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let searchResults = BehaviorSubject<[Place]>(value: [])
    var coordinator: SearchCoordinator?
    var dataSubject: PublishSubject = PublishSubject<String>()
    
    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    
    func searchField(_ keyword: String) {
        KakaoService.shared.fetchKakaoSearch(keyword)
            .subscribe(onNext: { [weak self] places in
                self?.searchResults.onNext(places)
            }, onError: { error in
                print("Error! : \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
}
