//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    
    weak var coordinator: HomeTabCoordinator?
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
        fetchRecruitRx()
    }
     
    var recruitObservable: BehaviorRelay = BehaviorRelay<[Recruit_Rx]>(value: [])
    
    func fetchRecruitRx() {
        _ = APIService.fetchRecruitRx()
            .map { data -> [Recruit_Rx] in
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.recruits
            }
            .map { menuItems -> [Recruit_Rx] in
                var recruits: [Recruit_Rx] = []
                menuItems.forEach { item in
                    let menu = Recruit_Rx(id: item.id, userName: item.userName, people: item.people, content: item.content, matchDate: item.matchDate, matchTime: item.matchTime, fieldName: item.fieldName, fieldAddress: item.fieldAddress)
                    recruits.append(menu)
                }
                return recruits
            }
            .take(1)
            .bind(to: recruitObservable)
    }
}

final class HomeViewModel1 {
    
    struct Input {
        
    }
    
    struct Output {
        let recruitList: Observable<Recruit>
    }
    
    // MARK: - Properties
    
    private let invokedViewDidLoad = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private weak var coordinator: HomeTabCoordinator?
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    
//    func transform(_ input: Input) -> Output {
//        
////        let recruitList = recruitList
//        
//        let output = Output(recruitList: <#T##Observable<Recruit>#>)
//        return output
//    }
    
    private func loadRecruitList(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
//            .accept
    }
    
}
