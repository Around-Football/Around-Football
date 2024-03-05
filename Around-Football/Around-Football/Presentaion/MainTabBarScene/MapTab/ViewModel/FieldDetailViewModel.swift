//
//  FieldDetailViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import Foundation

import RxSwift

final class FieldDetailViewModel {
    
    // MARK: - Properties
    
    private var recruits: [Recruit]
    private let firebaseAPI = FirebaseAPI.shared
    private let coordinator: MapTabCoordinator
    private let channelAPI = ChannelAPI.shared
    private let currentUser = UserService.shared.currentUser_Rx
    var recruitUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var recruitItem = BehaviorSubject<Recruit?>(value: nil)
    var recruitsCount: Int {
        return recruits.count
    }
    
    // MARK: - Lifecycles

    init(coordinator: MapTabCoordinator, recruits: [Recruit]) {
        self.coordinator = coordinator
        self.recruits = recruits
        fetchUser()
        fetchRecruit()
    }
    
    // MARK: - Helpers
    
    func fetchRecruit(row: Int) -> Recruit {
        return self.recruits[row]
    }
    
    func fetchFieldData() -> Recruit? {
        guard let fieldData = recruits.first else { return nil }
        return fieldData
    }
    
    func pushRecruitDetailView(recruit: Recruit) {
        self.coordinator.pushToDetailView(recruitItem: recruit)
    }
    
    // MARK: - API
    
    func checkChannelAndPushChatViewController(recruit: Recruit) {
        guard
            let currentUser = getCurrentUser(),
            let recruitUser = try? recruitUser.value()
        else {
            return
        }
        channelAPI.checkExistAvailableChannel(
            owner: currentUser,
            recruitID: recruit.id
        ) { [weak self] isAvailable, channelId in
            guard 
                isAvailable,
                let channelId = channelId
            else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: recruitUser, recruitID: recruit.id, recruitUserID: recruitUser.id)
                self?.coordinator.clickSendMessageButton(channelInfo: channelInfo, isNewChat: true)
                return
            }
            let channelInfo = ChannelInfo(id: channelId, withUser: recruitUser, recruitID: recruit.id, recruitUserID: recruitUser.id)
            self?.coordinator.clickSendMessageButton(channelInfo: channelInfo)
        }
    }
    
    func checkMyRecruit(recruit: Recruit) -> Bool {
        let currentUser = getCurrentUser()
        return currentUser?.id == recruit.userID ? true : false
    }
}

// MARK: - Private Methods

private extension FieldDetailViewModel {
    func getCurrentUser() -> User? {
        return try? currentUser.value()
    }
    
    func getRecruit() -> Recruit? {
        _ = recruits.map { recruit in
            recruitItem = BehaviorSubject(value: recruit)
        }
        return try? recruitItem.value()
    }
    
    func fetchUser() {
        guard let recruitUserId = getRecruit()?.userID else { return }
        FirebaseAPI.shared.fetchUser(uid: recruitUserId) { [weak self] user in
            guard let self = self else { return }
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
}
