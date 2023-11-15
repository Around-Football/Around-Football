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
//        let currentUser: Observable<User?>
        let isShowing: Observable<Bool>
    }
    
    // MARK: - Lifecycles
    
        init(coordinator: ChatTabCoordinator) {
            self.coordinator = coordinator
        }
    
    // MARK: - API
    
    func setupListener(currentUser: Observable<User?>) {
        currentUser
            .subscribe(onNext: { user in
                print(#function, "user:", user)
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
//        let currentUser = configureCurrentUser()
        setupListener(currentUser: self.currentUser.asObservable())
        let isShowing = configureShowingLoginView(by: input.invokedViewWillAppear)
        
        return Output(isShowing: isShowing)
    }
    
    // TODO: - AuthService 나오면 제거
    private func configureCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        currentUser
            .withUnretained(self)
            .filter { (_, user) in user != nil }
            .flatMap { (owner, _) -> Observable<User?> in
                print("inputobserver")
                return FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: "fcmToken")
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .do { [weak self] user in
                self?.currentUser.accept(user)
            }
//            .share()
    }
    
    private func configureShowingLoginView(by inputObserver: Observable<Void>) -> Observable<Bool> {
        
        return inputObserver
            .withUnretained(self)
            .flatMap({ (owner, _) -> Observable<Bool> in
                if owner.currentUser.value != nil { return .just(false) }
                return .just(true)
            })
            
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
