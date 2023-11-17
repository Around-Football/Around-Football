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

    var recruitObservable: BehaviorRelay = BehaviorRelay<[Recruit]>(value: [])

    func fetchRecruitRx() {
        _ = FirebaseAPI.shared.readRecruitRx()
            .bind(to: recruitObservable)
    }
}

final class HomeViewModel1 {
    
    struct Input {
        let invokedViewDidLoad: Observable<Void>
    }
    
    struct Output {
        let recruitList: Observable<[Recruit]>
    }
    
    weak var coordinator: HomeTabCoordinator?
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Properties
    
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitList = loadRecruitList(by: input.invokedViewDidLoad)
        let output = Output(recruitList: recruitList)
        return output
    }
    
    private func loadRecruitList(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.readRecruitRx()
                    .do(onNext: { recruits in
                        print("Recruits count in flatMap: \(recruits)")
                    }, onError: { error in
                        print("Error in flatMap: \(error)")
                    })
                
                print("돼라")
                
                return recruitObservable
            }
    }
}
