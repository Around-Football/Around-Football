//
//  DetailViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.


import Foundation

import RxSwift

final class DetailViewModel {
    
//    struct Input {
//        let invokedViewWillAppear: Observable<Void>
//    }
//    
//    struct Output {
//        let recruitItem: Observable<Recruit>
//    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let channelAPI = ChannelAPI()
    let currentUser = UserService.shared.currentUser_Rx
    weak var coordinator: DetailCoordinator?
    let recruitItem: BehaviorSubject<Recruit>
    var recruitUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var isSelectedBookmark: Bool?
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator?, recruitItem: Recruit) {
        self.coordinator = coordinator
        self.recruitItem = BehaviorSubject(value: recruitItem)
        fetchUser()
        fetchRecruit()
    }
    
    // MARK: - Helpers
    
//    func transform(_ input: Input) -> Output {
//        let output = Output(recruitItem: recruitItem)
//        return output
//    }
    
    private func fetchUser() {
        guard let recruitUserId = getRecruit()?.userID else { return }
        print("recruitUserId", recruitUserId)
        FirebaseAPI.shared.fetchUser(uid: recruitUserId) { [weak self] user in
            print("self?")
            guard let self = self else { return }
            print("user", user)
            self.recruitUser.onNext(user)
        }
    }
    
    func fetchRecruit() {
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
                let channelInfo = ChannelInfo(id: channelId, withUser: recruitUser, recruitID: recruitItem.id)
                self.coordinator?.clickSendMessageButton(channelInfo: channelInfo)
            } else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: recruitUser, recruitID: recruitItem.id)
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
            completion()
        }
    }
    
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
    
    func showApplicationStatusView(recruit: Recruit) {
        coordinator?.pushApplicationStatusViewController(recruit: recruit)
    }
    
    func isOwnRecruit() -> Bool {
        guard let currentUser = try? currentUser.value(),
              let recruit = try? recruitItem.value() else  { return false }
        return currentUser.id == recruit.userID ? true : false
    }
    
    func getCurrentUser() -> User? {
        return try? currentUser.value()
    }
    
    func getRecruit() -> Recruit? {
        return try? recruitItem.value()
    }
}


