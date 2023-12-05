//
//  ApplicationStatusViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxCocoa
import RxSwift

final class ApplicantListViewModel {
    
    struct Input {
        let loadApplicantList: Observable<String?>
    }
    
    struct Output {
        let applicantList: Observable<[String?]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: DetailCoordinator?
    var recruitItem: Recruit?
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        let applicantList = loadApplicationList(by: input.loadApplicantList)
        let output = Output(applicantList: applicantList)
        
        return output
    }
    
    private func loadApplicationList(by inputObserver: Observable<String?>) -> Observable<[String?]> {
        inputObserver
            .flatMap { fieldID -> Observable<[String?]> in
                let applicantListObservable = FirebaseAPI.shared.loadPendingApplicantRx(fieldID: fieldID)
                return applicantListObservable
            }
    }
    
}
