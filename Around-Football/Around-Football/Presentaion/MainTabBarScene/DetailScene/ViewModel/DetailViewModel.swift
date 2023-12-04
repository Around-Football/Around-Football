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
    
    private let disposeBag = DisposeBag()
    private let channelAPI = ChannelAPI()
    private let currentUser = UserService.shared.currentUser_Rx
    weak var coordinator: DetailCoordinator?
    let recruitItem: Recruit?
    var recruitUser: User?
    
    // MARK: - Lifecycles
    
    init(coordinator: DetailCoordinator, recruitItem: Recruit?) {
        self.coordinator = coordinator
        self.recruitItem = recruitItem
        fetchUser()
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitItem = loadRecruitItem(by: input.invokedViewWillAppear)
        checkChannel()
        let output = Output(recruitItem: recruitItem)
        return output
    }
    
    private func fetchUser() {
        guard let recruitItem = recruitItem else { return }
        FirebaseAPI.shared.fetchUser(uid: recruitItem.userID) { [weak self] user in
            guard let self = self else { return }
            self.recruitUser = user
        }
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
    func checkChannel() {
        guard let currentUser = try? currentUser.value(),
        let recruitUser = recruitUser else { return }
        channelAPI.checkExistAvailableChannel(owner: currentUser,
                                     withUser: recruitUser) { [weak self] isAvailable, channelId in
            guard let self = self else { return }
            print("DEBUG - ", #function, isAvailable)
            if isAvailable, let channelId = channelId {
                let channelInfo = ChannelInfo(id: channelId, withUser: recruitUser)
                self.coordinator?.pushChatViewController(channelInfo: channelInfo)
            } else {
                let channelInfo = ChannelInfo(id: UUID().uuidString, withUser: recruitUser)
                self.coordinator?.pushChatViewController(channelInfo: channelInfo, isNewChat: true)
            }
        }
    }
    
    private func pushChatViewController() {
        
    }
}
