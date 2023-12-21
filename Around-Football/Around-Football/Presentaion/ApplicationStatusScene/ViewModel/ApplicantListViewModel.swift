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
        let loadApplicantList: Observable<Void>
        let acceptButtonTapped: Observable<(String, String)>
        let rejectButtonTapped: Observable<(String, String)>
    }
    
    struct Output {
        let applicantList: Observable<[String]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: DetailCoordinator?
    var recruitItem: Recruit
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?, recruit: Recruit) {
        self.coordinator = coordinator
        self.recruitItem = recruit
    }
    
    func transform(_ input: Input) -> Output {
        let applicantList = loadApplicationList(by: input.loadApplicantList)
        let acceptedList = loadAcceptedApplicationList(by: input.acceptButtonTapped.asObservable())
        let rejectedList = loadRejectedApplicationList(by: input.rejectButtonTapped.asObservable())
        
        let list = Observable.merge(applicantList, acceptedList, rejectedList)
        
        let output = Output(applicantList: list)
        
        return output
    }
    
    private func loadApplicationList(by inputObserver: Observable<Void>) -> Observable<[String]> {
        inputObserver
            .flatMap { _ -> Observable<[String]> in
                let applicantListObservable = FirebaseAPI.shared.loadPendingApplicantRx(recruitID: self.recruitItem.id)
                return applicantListObservable
            }
    }
    
    private func loadAcceptedApplicationList(by inputObserver: Observable<(String, String)>) -> Observable<[String]> {
        inputObserver
            .flatMap { (recruitID, uid) -> Observable<[String]> in
                let applicantListObservable = FirebaseAPI.shared.loadAcceptedApplicantRx(recruitID: recruitID, uid: uid)
                return applicantListObservable
            }
    }
    
    private func loadRejectedApplicationList(by inputObserver: Observable<(String, String)>) -> Observable<[String]> {
        inputObserver
            .flatMap { (recruitID, uid) -> Observable<[String]> in
                let applicantListObservable = FirebaseAPI.shared.loadRejectedApplicantRx(recruitID: recruitID, uid: uid)
                return applicantListObservable
            }
    }
}
