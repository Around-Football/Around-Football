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
        let filteringDate: Observable<String?>
        let filteringType: Observable<String?>
        let filteringRegion: Observable<String?>
    }
    
    struct Output {
        let recruitList: Observable<[Recruit]>
        let filteredDateRecruitList: Observable<[Recruit]>
        let filteredTypeRecruitList: Observable<[Recruit]>
        let filteredRegionRecruitList: Observable<[Recruit]>
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
        let filteredDate = loadRecruitDateList(by: input.filteringDate)
        let filteredType = loadRecruitTypeList(by: input.filteringType)
        let filteredRegion = loadRecruitRegionList(by: input.filteringRegion)
        let output = Output(recruitList: recruitList,
                            filteredDateRecruitList: filteredDate,
                            filteredTypeRecruitList: filteredType,
                            filteredRegionRecruitList: filteredRegion)
        return output
    }
    
    private func loadRecruitList(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.readRecruitRx()
                return recruitObservable
            }
    }
    
    private func loadRecruitDateList(by inputObserver: Observable<String?>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { date -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.fetchRecruitDate(date: date)
                return recruitObservable
            }
    }
    
    private func loadRecruitRegionList(by inputObserver: Observable<String?>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { region -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.fetchRecruitRegion(region: region)
                return recruitObservable
            }
    }
    
    private func loadRecruitTypeList(by inputObserver: Observable<String?>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { type -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.fetchRecruitType(type: type)
                return recruitObservable
            }
    }
}
