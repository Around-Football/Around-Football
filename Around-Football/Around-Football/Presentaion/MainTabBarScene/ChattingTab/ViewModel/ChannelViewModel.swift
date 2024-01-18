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
        let selectedSegment: Observable<Int>
        let invokedDeleteChannel: Observable<ChannelInfo>
    }
    
    struct Output {
        let isShowing: Observable<Bool>
        let segmentChannels: BehaviorRelay<[ChannelInfo]>
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
                if let _ = user {
                    owner.channelAPI.subscribe()
                        .asObservable()
                        .subscribe(onNext: { result in
                            result.forEach { channelInfo, documentChangeType in
                                var channelInfo = channelInfo
                                if let url = channelInfo.downloadURL {
                                    StorageAPI.downloadImage(url: url) { image in
                                        if let image = image {
                                            channelInfo.image = image
                                        }
                                        owner.updateCell(to: (channelInfo, documentChangeType))
                                    }
                                } else {
                                    owner.updateCell(to: (channelInfo, documentChangeType))
                                }
                            }
                        }, onError: { error in
                            print("DEBUG - setupListener Error: \(error.localizedDescription)")
                            
                        })
                        .disposed(by: owner.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    private func updateCell(to data: (ChannelInfo, DocumentChangeType)) {
        var currentChannels = channels.value
        let (channel, documentChangeType) = data
            switch documentChangeType {
            case .added:
                guard currentChannels.contains(channel) == false else { return }
                currentChannels.append(channel)
                currentChannels.sort()
                
            case .modified:
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels[index] = channel
                currentChannels.sort()
                
            case .removed:
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels.remove(at: index)
            }
        channels.accept(currentChannels)
    }
    
    func transform(_ input: Input) -> Output {
        setupListener(currentUser: self.currentUser.asObservable())
        deleteChannelInfo(by: input.invokedDeleteChannel)
        let isShowing = configureShowingLoginView(by: input.invokedViewWillAppear)
        let channels = emitSelectedSegmentChannelInfo(by: input.selectedSegment)
        return Output(isShowing: isShowing, segmentChannels: channels)
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
    
    private func emitSelectedSegmentChannelInfo(by inputObserver: Observable<Int>) -> BehaviorRelay<[ChannelInfo]> {
        let result = BehaviorRelay<[ChannelInfo]>(value: [])

        Observable.combineLatest(channels, inputObserver)
            .withUnretained(self)
            .flatMap({ (owner, observe) -> Observable<[ChannelInfo]> in
                let channels = observe.0
                let index = observe.1
                guard let currentUser = try? owner.currentUser.value() else { return .just([]) }
                if index == 0 {
                    return .just(channels.filter { $0.recruitUserID != currentUser.id})
                } else {
                    return .just(channels.filter { $0.recruitUserID == currentUser.id})
                }
            })
            .bind(to: result)
            .disposed(by: disposeBag)
        
        return result
    }
    
    private func deleteChannelInfo(by inputObserver: Observable<ChannelInfo>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, channelInfo) in
                guard let currentUser = try? owner.currentUser.value() else { return }
                let channelId = channelInfo.id
                let withUserId = channelInfo.withUserId
                owner.channelAPI.resetAlarmNumber(uid: currentUser.id, channelId: channelInfo.id) {
                    FirebaseAPI.shared.fetchUser(uid: currentUser.id) { user in
                        guard let user = user else { return }
                        UserService.shared.currentUser_Rx.onNext(user)
                        NotiManager.shared.setAppIconBadgeNumber(number: user.totalAlarmNumber)
                    }
                    
                    owner.channelAPI.deleteChannelInfo(uid: currentUser.id, channelId: channelId)
                    if channelInfo.isAvailable {
                        owner.channelAPI.updateDeleteChannelInfo(withUserId: withUserId, channelId: channelId)
                        
                        let deleteChannelMessage = Message(user: currentUser, content: "", messageType: .inform)
                        ChatAPI.shared.save([deleteChannelMessage], channelId: channelId)
                    } else {
                        owner.channelAPI.deleteChannel(channelId: channelId)
                    }
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
    
    func deinitChildCoordinator() {
        coordinator?.deinitCoordinator()
    }
}
