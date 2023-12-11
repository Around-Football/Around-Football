//
//  ChannelViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

import Firebase
import FirebaseFirestore
import RxSwift
import RxRelay

final class ChannelViewModel {
    
    // MARK: - Properties
    
    var channels: BehaviorRelay<[ChannelInfo]> = BehaviorRelay(value: [])
    let channelAPI: ChannelAPI = ChannelAPI.shared
    var currentUser = UserService.shared.currentUser_Rx
    
    weak var coordinator: ChatTabCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
        let selectedChannel: Observable<IndexPath>
        let invokedDeleteChannel: Observable<IndexPath>
    }
    
    struct Output {
        let isShowing: Observable<Bool>
        let navigateTo: Observable<ChannelInfo>
    }
    
    // MARK: - Lifecycles
    
    init(coordinator: ChatTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - API
    
    private func setupListener(currentUser: Observable<User?>) {
        currentUser
            .withUnretained(self)
            .filter({ (owner, user) in user != nil })
            .subscribe(onNext: { (owner, user) in
                print(#function, "user:", user as Any)
                if let _ = user {
                    owner.channelAPI.subscribe()
                        .asObservable()
                        .subscribe(onNext: { result in
                            owner.updateCell(to: result)
                        }, onError: { error in
                            print("DEBUG - setupListener Error: \(error.localizedDescription)")
                            
                        })
                        .disposed(by: owner.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    private func updateCell(to data: [(ChannelInfo, DocumentChangeType)]) {
        var currentChannels = channels.value
        data.forEach { channel, documentChangeType in
            switch documentChangeType {
            case .added:
                guard currentChannels.contains(channel) == false else { return }
                currentChannels.append(channel)
                currentChannels.sort()
                
            case .modified:
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels[index] = channel
                
            case .removed:
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels.remove(at: index)
            }
        }
        channels.accept(currentChannels)
    }
    
    func transform(_ input: Input) -> Output {
        setupListener(currentUser: self.currentUser.asObservable())
        deleteChannelInfo(by: input.invokedDeleteChannel)
        let isShowing = configureShowingLoginView(by: input.invokedViewWillAppear)
        let navigateTo = emitSelectedChannelInfo(by: input.selectedChannel)
        return Output(isShowing: isShowing, navigateTo: navigateTo)
    }
    
    private func configureShowingLoginView(by inputObserver: Observable<Void>) -> Observable<Bool> {
        
        return inputObserver
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self else { return .just(true) }
                do {
                    if let _ = try currentUser.value() {
                        return .just(false)
                    }
                    return .just(true)
                } catch {
                    return .just(true)
                }
            }
    }
    
    private func emitSelectedChannelInfo(by inputObserver: Observable<IndexPath>)
    -> Observable<ChannelInfo> {
        inputObserver
            .withLatestFrom(channels) { (indexPath, channels) -> ChannelInfo in
                return channels[indexPath.row]
            }
    }
    
    private func deleteChannelInfo(by inputObserver: Observable<IndexPath>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, indexPath) in
                guard let currentUser = try? owner.currentUser.value() else { return }
                let channelInfo = owner.channels.value[indexPath.row]
                let channelId = channelInfo.id
                let withUserId = channelInfo.withUserId
                owner.channelAPI.deleteChannelInfo(uid: currentUser.id, channelId: channelId)
                if channelInfo.isAvailable {
                    owner.channelAPI.updateDeleteChannelInfo(withUserId: withUserId, channelId: channelId)
                    
                    let deleteChannelMessage = Message(user: currentUser, content: "", messageType: .inform)
                    ChatAPI.shared.save([deleteChannelMessage], channelId: channelId)
                } else {
                    owner.channelAPI.deleteChannel(channelId: channelId)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func showChatView(channelInfo: ChannelInfo) {
        coordinator?.pushChatView(channelInfo: channelInfo)
    }
    
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
    
    func showDeleteAlertView(alert: UIAlertController) {
        coordinator?.presentDeleteAlertController(alert: alert)
    }
    
    func removeListner() {
        channelAPI.removeListener()
    }
}
