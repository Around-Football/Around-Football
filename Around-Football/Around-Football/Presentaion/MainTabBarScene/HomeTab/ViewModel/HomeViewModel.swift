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
        let invokedViewWillAppear: Observable<Void>
        let filteringType: Observable<String?>
    }
    
    struct Output {
        let recruitList: Observable<[Recruit]>
        let filteredTypeRecruitList: Observable<[Recruit]>
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    weak var coordinator: HomeTabCoordinator?
    
    // MARK: - Lifecycles
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitList = loadRecruitList(by: input.invokedViewWillAppear)
        let filteredTypeRecruitList = loadRecruitTypeList(by: input.filteringType)
        let output = Output(recruitList: recruitList, filteredTypeRecruitList: filteredTypeRecruitList)
        return output
    }
    
    private func loadRecruitList(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.readRecruitRx()
                return recruitObservable
            }
    }
    
    private func loadRecruitTypeList(by inputObserver: Observable<String?>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { type -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.fetchRecruitFieldDataType(type: type)
                return recruitObservable
            }
    }
}
