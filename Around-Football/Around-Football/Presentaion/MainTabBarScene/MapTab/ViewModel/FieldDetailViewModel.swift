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
    var recruitsCount: Int {
        return recruits.count
    }
    
    // MARK: - Lifecycles

    init(coordinator: MapTabCoordinator, recruits: [Recruit]) {
        self.coordinator = coordinator
        self.recruits = recruits
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
            guard let self = self else { return }
            print("DEBUG - ", #function, isAvailable)
            if isAvailable, let channelId = channelId {
                let channelInfo = ChannelInfo(id: channelId, withUser: recruitUser, recruitID: recruit.id, recruitUserID: recruitUser.id)
                self.coordinator.clickSendMessageButton(channelInfo: channelInfo)
            } else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: recruitUser, recruitID: recruit.id, recruitUserID: recruitUser.id)
                self.coordinator.clickSendMessageButton(channelInfo: channelInfo, isNewChat: true)
            }
        }
    }
    
    private func getCurrentUser() -> User? {
        return try? currentUser.value()
    }
}
