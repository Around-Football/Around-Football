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
    
    weak var coordinator: SearchCoordinator?
    var dataSubject: PublishSubject = PublishSubject<Place>()
    var searchResults = BehaviorSubject<[Place]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
    }
    
    func searchFields(keyword: String, disposeBag: DisposeBag) {
        KakaoService.shared.searchField(keyword, searchResults, disposeBag)
    }
    
    func setEmptySearchResults() {
        self.searchResults = BehaviorSubject<[Place]>(value: [])
    }
}
