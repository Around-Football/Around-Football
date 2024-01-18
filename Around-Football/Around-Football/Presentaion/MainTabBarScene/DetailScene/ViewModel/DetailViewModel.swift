//
//  DetailViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.


import Foundation

import RxSwift

final class DetailViewModel {
    
    enum RecruitStatus {
        case close
        case applied
        case ownRecruit
        case availableRecruit

        var statusDescription: String {
            switch self {
            case .applied: return "신청 완료"
            case .close: return "신청 마감"
            case .availableRecruit: return "신청하기"
            case .ownRecruit: return "신청 현황 보기"
            }
        }
    }
    
        struct Input {
            let invokedViewWillAppear: Observable<Void>
        }
    
        struct Output {
            let recruitStatus: Observable<(RecruitStatus)>
        }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let channelAPI = ChannelAPI.shared
    private let currentUser = UserService.shared.currentUser_Rx
    private weak var coordinator: DetailCoordinator?
    let recruitItem: BehaviorSubject<Recruit>
    var recruitUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var isSelectedBookmark: Bool = false
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?, recruitItem: Recruit) {
        self.coordinator = coordinator
        self.recruitItem = BehaviorSubject(value: recruitItem)
        fetchUser()
        fetchRecruit()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        guard let recruitUserId = getRecruit()?.userID else { return }
        FirebaseAPI.shared.fetchUser(uid: recruitUserId) { [weak self] user in
            guard let self = self else { return }
            self.recruitUser.onNext(user)
        }
    }
    
    private func fetchRecruit() {
        guard let recruit = getRecruit() else { return }
        FirebaseAPI.shared.fetchRecruit(recruitID: recruit.id) { [weak self] recruit, error in
            guard let self = self else { return }
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
            }
            
            if let recruit = recruit {
                self.recruitItem.onNext(recruit)
            }
        }
    }
    
    func checkChannelAndPushChatViewController() {
        guard let currentUser = getCurrentUser(),
              let recruitUser = try? recruitUser.value(),
              let recruitItem = getRecruit() else { return }
        channelAPI.checkExistAvailableChannel(owner: currentUser,
                                              recruitID: recruitItem.id) { [weak self] isAvailable, channelId in
            guard let self = self else { return }
            print("DEBUG - ", #function, isAvailable)
            if isAvailable, let channelId = channelId {
                let channelInfo = ChannelInfo(id: channelId, withUser: recruitUser, recruitID: recruitItem.id, recruitUserID: recruitUser.id)
                self.coordinator?.clickSendMessageButton(channelInfo: channelInfo)
            } else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: recruitUser, recruitID: recruitItem.id, recruitUserID: recruitUser.id)
                self.coordinator?.clickSendMessageButton(channelInfo: channelInfo, isNewChat: true)
            }
        }
    }
    
    func addBookmark(completion: @escaping(() -> Void)) {
        guard var user = getCurrentUser(),
              let recruit = getRecruit() else { return }
        user.bookmarkedRecruit.append(recruit.id)
        
        FirebaseAPI.shared.updateUser(user) { error in
            guard error == nil else { return }
            self.isSelectedBookmark = true
            completion()
        }
    }
    
    func removeBookmark(completion: @escaping(() -> Void)) {
        guard var user = getCurrentUser(),
              let recruit = getRecruit() else { return }
        user.bookmarkedRecruit.removeAll { id in
            recruit.id == id
        }
        
        FirebaseAPI.shared.updateUser(user) { error in
            guard error == nil else { return }
            self.isSelectedBookmark = false

            completion()
        }
    }
    
    func sendRecruitApplicant() {
        guard let recruit = getRecruit(),
              let recruitUser = try? recruitUser.value(),
              let user = getCurrentUser() else { return }
        FirebaseAPI.shared.appendPendingApplicant(recruitID: recruit.id, userID: user.id) { [weak self] error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
                return
            }
            self?.fetchRecruit()
            NotiManager.shared.pushApplicantNotification(recruit: recruit, receiverFcmToken: recruitUser.fcmToken)
        }
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitStatus = emitButtonStyleCalculator(by: input.invokedViewWillAppear)
        fetchRecruitObservable(by: input.invokedViewWillAppear)
        let output = Output(recruitStatus: recruitStatus)
        return output
    }
    
    private func fetchRecruitObservable(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.fetchRecruit()
            }
            .disposed(by: disposeBag)
    }
    
    private func emitButtonStyleCalculator(by inputObserver: Observable<Void>) -> Observable<RecruitStatus> {
        return Observable.combineLatest(inputObserver, currentUser, recruitItem)
            .withUnretained(self)
            .flatMapLatest { (owner, observers) -> Observable<RecruitStatus> in
                guard let currentUser = observers.1,
                      let recruitItem = owner.getRecruit() else { return Observable.just(.availableRecruit) }
                if currentUser.id == recruitItem.userID { return Observable.just(.ownRecruit) }

                //시간이 과거면 마감으로 표시
                if owner.isDateInFuture(targetDate: recruitItem.matchDate.dateValue()) {
                    return Observable.just(.close)
                }
                
                if recruitItem.pendingApplicantsUID.contains(currentUser.id) {
                    return Observable.just(.applied)
                }
                
                if recruitItem.acceptedApplicantsUID.count == recruitItem.recruitedPeopleCount {
                    return Observable.just(.close)
                }

                
                return Observable.just(.availableRecruit)
            }
    }
    
    func deleteRecruit() {
        guard let recruit = getRecruit() else { return }
        FirebaseAPI.shared.deleteRecruit(recruitID: recruit.id) { [weak self] error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
                return
            }
            guard let self = self else { return }
            
            FirebaseAPI.shared.fetchUsersRx(uids: recruit.acceptedApplicantsUID)
                .take(1)
                .bind { users in
                    print("DEBUG - APPLICANT")
                    users.forEach { NotiManager.shared.pushDeleteNotification(recruit: recruit, receiverFcmToken: $0.fcmToken)}
                }
                .disposed(by: disposeBag)
            coordinator?.popDetailViewController()
        }
    }
    
    func getCurrentUser() -> User? {
        return try? currentUser.value()
    }
    
    func getRecruit() -> Recruit? {
        return try? recruitItem.value()
    }
    
    //모집Date 비교
    func isDateInFuture(targetDate: Date) -> Bool {
        let currentDate = Date()
        let comparisonResult = currentDate.compare(targetDate)
        return comparisonResult == .orderedDescending
    }
    
    // MARK: - Coordinator
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
    
    func showApplicationStatusView() {
        guard let recruit = getRecruit() else { return }
        coordinator?.pushApplicationStatusViewController(recruit: recruit)
    }
    
    func showEditDetailView() {
        guard let recruit = getRecruit() else { return }
        coordinator?.showEditDetailView(recruit: recruit)
    }
}


