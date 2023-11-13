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
    
    var channels: [ChannelInfo] = []
    var currentUser: User?
    
    weak var coordinator: ChatTabCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let invokedViewDidLoad: Observable<Void>
    }
    
    struct Output {
        let currentUser: Observable<User?>
        let channels: Observable<[ChannelInfo]>
    }
    
    // MARK: - Lifecycles
    
    //    init(coordinator: ChatTabCoordinator) {
    //        self.coordinator = coordinator
    //    }
    
    // MARK: - API
    
    //    func setupListener() {
    //        ChannelAPI.shared.subscribe { [weak self] result in
    //            guard let self = self else { return }
    //            switch result {
    //            case .success(let data):
    //                self.updateCell(to: data)
    //            case .failure(let error):
    //                print("DEBUG - setupListener Error: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    
    func setupListener() {
        ChannelAPI.shared.subscribe()
            .subscribe { result in
                switch result {
                case .success(let data):
                    self.updateCell(to: data)
                case .failure(let error):
                    print("DEBUG - setupListener Error: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    //    func fetchUser() {
    //        let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
    //        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
    //        FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken) { [weak self] user, error in
    //            if let error = error {
    //                print("DEBUG - FetchUser Error: ", #function, error.localizedDescription)
    //                return
    //            }
    //            guard let self = self else { return }
    //            self.currentUser = user
    //            print("DEBUG - CurrentUser: \(String(describing: self.currentUser))")
    //
    //        }
    //    }
    // MARK: - Helpers
    
    private func updateCell(to data: [(ChannelInfo, DocumentChangeType)]) {
        data.forEach { channel, documentChangeType in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: ChannelInfo) {
        guard channels.contains(channel) == false else { return }
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else { return }
        // TODO: - RX 적용하기
        //                channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: ChannelInfo) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        
        // TODO: - RX 적용하기
        //        channtlTableView.reloatRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: ChannelInfo) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        
        
        // TODO: - RX 적용하기
        //        channtlTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func transform(_ input: Input) -> Output {
        let currentUser = configureCurrentUser(by: input.invokedViewDidLoad)
        let channels = configureChannelInfo(by: input.invokedViewDidLoad, currentUser: currentUser)
        
        return Output(currentUser: currentUser, channels: channels)
    }
    
    
    private func configureCurrentUser(by inputObserver: Observable<Void>) -> Observable<User?> {
        let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        return inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<User?> in
                return FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken)
                    .asObservable()
                    .catchAndReturn(nil)
                
            }
            .do { [weak self] user in
                self?.currentUser = user
            }
    }
    
    private func configureChannelInfo(by inputObserver: Observable<Void>, currentUser: Observable<User?>) -> Observable<[ChannelInfo]> {
        return currentUser
            .withUnretained(self)
            .flatMap({ owner, user -> Observable<[ChannelInfo]> in
                guard user != nil else { return .empty() }
                return ChannelAPI.shared.subscribe().asObservable()
                    .catchAndReturn([])
                    .do { result in
                        owner.updateCell(to: result)
                    }
                    .map { _ in owner.channels }
            })
    }
    
    
    
    func showChatView() {
        coordinator?.pushChatView()
    }
    
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
}
