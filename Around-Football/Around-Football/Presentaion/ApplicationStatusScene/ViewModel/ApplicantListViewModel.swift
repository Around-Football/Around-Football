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
            case .accepted: return "취소하기"
            case .availaleAccept: return "수락하기"
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
    private let channelAPI = ChannelAPI.shared
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?, recruit: Recruit) {
        self.coordinator = coordinator
        self.recruitItem = BehaviorSubject(value: recruit)
    }
    
    // MARK: - Bind
    
    func transform(_ input: Input) -> Output {
        let users = fetchUsers(by: input.invokedViewDidLoad)
        let userList = emitCombinedObservableUser(by: users)
        
        let output = Output(userList: userList)
        
        return output
    }
    
    private func fetchRecruit() {
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
    
    // MARK: - Helpers
    
    func getRecruit() -> Recruit {
        return try! recruitItem.value()
    }
    
    func getCurrentUser() -> User {
        return try! UserService.shared.currentUser_Rx.value()!
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
    
    func acceptApplicantion(user: User) {
        let recruit = getRecruit()
        FirebaseAPI.shared.acceptApplicants(recruitID: recruit.id, userID: user.id) { [weak self] error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
                return
            }
            guard let self = self else { return }
            self.fetchRecruit()
            NotiManager.shared.pushAcceptNotification(recruit: recruit, receiverFcmToken: user.fcmToken)
            checkChannelAndSendApproveMessage(user: user)
            
            print("DEBUG - ACCEPT")
        }
    }
    
    func cancelApplicantion(user: User) {
        let recruit = getRecruit()
        FirebaseAPI.shared.cancelApplicants(recruitID: recruit.id, userID: user.id) { [weak self] error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
                return
            }
            guard let self = self else { return }
            self.fetchRecruit()
            NotiManager.shared.pushCancelNotification(recruit: recruit, receiverFcmToken: user.fcmToken)
            print("DEBUG - CANCEL")
        }
    }
        
    private func checkChannel(user: User, completion: @escaping((ChannelInfo, Bool) -> Void)) {
        let currentUser = getCurrentUser()
        let recruit = getRecruit()
        channelAPI.checkExistAvailableChannel(owner: currentUser,
                                              recruitID: recruit.id) { isAvailable, channelId in
            print("DEBUG - ", #function, isAvailable)
            if isAvailable, let channelId = channelId {
                let channelInfo = ChannelInfo(id: channelId, withUser: user, recruitID: recruit.id, recruitUserID: recruit.userID)
                completion(channelInfo, true)
            } else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: user, recruitID: recruit.id, recruitUserID: recruit.userID)
                completion(channelInfo, false)
            }
        }
    }
    
    private func checkChannelAndSendApproveMessage(user: User) {
        let currentUser = getCurrentUser()
        let recruit = getRecruit()
        checkChannel(user: user) { channelInfo, isAvailable in
            let message = Message(user: currentUser, content: "\(recruit.matchDayAndStartTime) 건에 대한 용병 신청이 수락되었습니다.", messageType: .inform)
            if isAvailable {
                ChatAPI.shared.save([message], channelId: channelInfo.id)
                self.channelAPI.updateChannelInfo(owner: currentUser,
                                             withUser: user,
                                             channelId: channelInfo.id,
                                             message: message)
                self.channelAPI.updateTotalAlarmNumber(uid: user.id, alarmNumber: 1)

            } else {
                self.channelAPI.createChannel(channelInfo: channelInfo) {
                    ChatAPI.shared.save([message], channelId: channelInfo.id)
                    self.channelAPI.updateChannelInfo(owner: currentUser,
                                                 withUser: user,
                                                 channelId: channelInfo.id,
                                                 message: message)
                    self.channelAPI.updateTotalAlarmNumber(uid: user.id, alarmNumber: 1)
                }
            }
        }
    }
    
    func checkChannelAndPushChatViewController(user: User) {
        checkChannel(user: user) { channelInfo, isAvailable in
            if isAvailable {
                self.pushChatViewcontroller(channelInfo: channelInfo)
            } else {
                self.pushChatViewcontroller(channelInfo: channelInfo, isNewChat: true)
            }
        }
    }
    
    private func pushChatViewcontroller(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        coordinator?.clickSendMessageButton(channelInfo: channelInfo, isNewChat: isNewChat)
    }
    
    func removeChildCoordinator() {
        coordinator?.removeChatCoordinator()
    }
}
