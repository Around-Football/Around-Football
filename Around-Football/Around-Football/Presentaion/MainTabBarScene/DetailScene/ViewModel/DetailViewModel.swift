//
//  DetailViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift

final class DetailViewModel {
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let recruitItem: Observable<Recruit>
    }
    
    // MARK: - Properties
    
    weak var coordinator: DetailCoordinator?
    private let disposeBag = DisposeBag()
    let recruitItem: Recruit?
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator, recruitItem: Recruit?) {
        self.coordinator = coordinator
        self.recruitItem = recruitItem
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitItem = loadRecruitItem(by: input.invokedViewWillAppear)
        let output = Output(recruitItem: recruitItem)
        return output
    }
    
    private func loadRecruitItem(by inputObserver: Observable<Void>) -> Observable<Recruit> {
        inputObserver
            .flatMap { [weak self] () -> Observable<Recruit> in
                guard let self else { return Observable.empty() }
                return Observable.create { observer in
                    guard let recruitItem = self.recruitItem else { return Disposables.create()
                    }
                    observer.onNext(recruitItem)
                    observer.onCompleted()
                    
                    return Disposables.create()
                }
            }
    }
}
