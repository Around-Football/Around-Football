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
    var currentUser: PublishRelay<User>?
    
    weak var coordinator: ChatTabCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let invokedViewDidLoad: Observable<Void>
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
        guard channels.value.contains(channel) == false else { return }
        var newChannels = self.channels.value
        newChannels.append(channel)
        newChannels.sort()
        
        channels.accept(newChannels)
        guard let index = channels.value.firstIndex(of: channel) else { return }
        // TODO: - RX 적용하기
        //                channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: ChannelInfo) {
        guard let index = channels.value.firstIndex(of: channel) else { return }
        var newChannels = self.channels.value
        newChannels[index] = channel
        
        channels.accept(newChannels)
        // TODO: - RX 적용하기
        //        channtlTableView.reloatRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: ChannelInfo) {
        guard let index = channels.value.firstIndex(of: channel) else { return }
        var newChannels = self.channels.value
        newChannels.remove(at: index)
        
        channels.accept(newChannels)
        
        // TODO: - RX 적용하기
        //        channtlTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func transform(_ input: Input) {
        input.invokedViewDidLoad
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
                let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
                FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken)
                    .subscribe { [weak self] user in
                        guard let self = self else { return }
                        self.currentUser?.accept(user)
                        print("DEBUG - CurrentUser: \(String(describing: self.currentUser))")
                    } onFailure: { error in
                        print("DEBUG - FetchUser Error: ", #function, error.localizedDescription)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func showChatView() {
        coordinator?.pushChatView()
    }
    
    func showLoginView() {
        coordinator?.presentLoginViewController()
    }
}
