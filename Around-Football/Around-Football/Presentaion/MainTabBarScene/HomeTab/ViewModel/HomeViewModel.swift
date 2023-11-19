//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import Foundation

import RxSwift

final class HomeViewModel {
    
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
                return recruitObservable
            }
    }
}
