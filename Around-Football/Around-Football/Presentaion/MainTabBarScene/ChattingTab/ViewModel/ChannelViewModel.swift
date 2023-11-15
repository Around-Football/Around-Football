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
    var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    
    weak var coordinator: ChatTabCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let currentUser: Observable<User?>
    }
    
    // MARK: - Lifecycles
    
        init(coordinator: ChatTabCoordinator) {
            self.coordinator = coordinator
        }
    
    // MARK: - API
    
    func setupListener(currentUser: Observable<User?>) {
        currentUser
            .subscribe(onNext: { user in
                if let _ = user {
                    ChannelAPI.shared.subscribe()
                        .asObservable()
                        .subscribe(onNext: { result in
                            print("channels")
                            print(result)
                            self.updateCell(to: result)

                        }, onError: { error in
                            print("DEBUG - setupListener Error: \(error.localizedDescription)")

                        })
                        .disposed(by: self.disposeBag)
                } else {
                    print("nochannels")
                    self.channels.accept([])
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
                print("added")
                guard currentChannels.contains(channel) == false else { return }
                currentChannels.append(channel)
                currentChannels.sort()
                
            case .modified:
                print("Modified")
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels[index] = channel
            case .removed:
                print("removed")
                guard let index = currentChannels.firstIndex(of: channel) else { return }
                currentChannels.remove(at: index)
            }
        }
        channels.accept(currentChannels)
    }
        
    func transform(_ input: Input) -> Output {
        let currentUser = configureCurrentUser(by: input.invokedViewWillAppear)
        setupListener(currentUser: currentUser)
        
        return Output(currentUser: currentUser)
    }
    
    
    private func configureCurrentUser(by inputObserver: Observable<Void>) -> Observable<User?> {
        guard let uid = Auth.auth().currentUser?.uid else { return .just(nil) }
        
        
        return inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<User?> in
                print("inputobserver")
                return FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: "fcmToken")
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .do { [weak self] user in
                self?.currentUser.accept(user)
            }
            .share()
    }
    
    
    func showChatView() {
        coordinator?.pushChatView()
    }
    
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
    
    func removeListner() {
        ChannelAPI.shared.removeListener()
    }
}
