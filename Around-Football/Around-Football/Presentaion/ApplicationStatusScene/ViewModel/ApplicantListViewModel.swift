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
    
    enum ApplicantStatus {
        case close
        case accepted
        case availaleAccept

        var statusDescription: String {
            switch self {
            case .close: return "마감"
            case .accepted: return "완료"
            case .availaleAccept: return "수락"
            }
        }
    }
    
    struct Input {
        let invokedViewDidLoad: Observable<Void>
    }
    
    struct Output {
        let userList: Observable<[User]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: DetailCoordinator?
    var recruitItem: BehaviorSubject<Recruit>
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?, recruit: Recruit) {
        self.coordinator = coordinator
        self.recruitItem = BehaviorSubject(value: recruit)
    }
    
    func transform(_ input: Input) -> Output {
        let users = fetchUsers(by: input.invokedViewDidLoad)
        let userList = emitCombinedObservableUser(by: users)
        
        let output = Output(userList: userList)
        
        return output
    }
    
    func fetchRecruit() {
        let recruit = getRecruit()
        FirebaseAPI.shared.fetchRecruit(recruitID: recruit.id) { [weak self] recruit, error in
            guard let self = self else { return }
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
                return
            }
            guard let recruit = recruit else { return }
            recruitItem.onNext(recruit)
        }
    }
    
    private func fetchUsers(by inputObserver: Observable<Void>) -> Observable<[User]> {
        let recruit = getRecruit()
        return inputObserver
            .flatMap({ _ -> Observable<[User]> in
                FirebaseAPI.shared.fetchUsersRx(uids: recruit.pendingApplicantsUID)
            })
    }
    
    /// tableView에 바인딩할 users는 한번 패치한 Observable<[User]>와 recruit을 구독한 user
    /// recruit가 변화될 때마다 fetch하는 것을 방지(fetch는 한번만 진행)
    /// 따라서 recruit가 변화될 때마다 tableView는 갱신됨
    
    private func emitCombinedObservableUser(by inputObserve: Observable<[User]>) -> Observable<[User]> {
        return Observable.combineLatest(inputObserve, self.recruitItem)
            .withUnretained(self) { owner, result in
                return result.0
            }
    }
    
    func getRecruit() -> Recruit {
        return try! recruitItem.value()
    }
    
    func emitApplicantStatusCalculator(uid: String) -> ApplicantStatus {
        let recruit = getRecruit()
        
        if recruit.acceptedApplicantsUID.contains(uid) {
            return .accepted
        }
        
        if recruit.acceptedApplicantsUID.count == recruit.recruitedPeopleCount {
            return .close
        }
        
        return .availaleAccept
    }
    
//    private func loadApplicationList(by inputObserver: Observable<Void>) -> Observable<[String]> {
//        inputObserver
//            .flatMap { _ -> Observable<[String]> in
//                let applicantListObservable = FirebaseAPI.shared.loadPendingApplicantRx(recruitID: self.recruitItem.id)
//                return applicantListObservable
//            }
//    }
//    
//    private func loadAcceptedApplicationList(by inputObserver: Observable<(String, String)>) -> Observable<[String]> {
//        inputObserver
//            .flatMap { (recruitID, uid) -> Observable<[String]> in
//                let applicantListObservable = FirebaseAPI.shared.loadAcceptedApplicantRx(recruitID: recruitID, uid: uid)
//                return applicantListObservable
//            }
//    }
//    
//    private func loadRejectedApplicationList(by inputObserver: Observable<(String, String)>) -> Observable<[String]> {
//        inputObserver
//            .flatMap { (recruitID, uid) -> Observable<[String]> in
//                let applicantListObservable = FirebaseAPI.shared.loadRejectedApplicantRx(recruitID: recruitID, uid: uid)
//                return applicantListObservable
//            }
//    }
}
