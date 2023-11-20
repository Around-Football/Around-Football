//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift
import RxRelay
import Firebase
import FirebaseAuth
import MessageKit

class ChatViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: ChatTabCoordinator?
    
    let disposeBag = DisposeBag()
    var channel: BehaviorRelay<Channel?> = BehaviorRelay(value: nil)
    var messages: BehaviorRelay<[Message]> = BehaviorRelay(value: [])
    let currentUser: User? = UserService.shared.currentUser_Rx.value
    let withUser: User? = nil
    var isNewChat: Bool = false
    
    private let chatAPI = ChatAPI.shared
    private let channelAPI = ChannelAPI.shared

    var currentSender: MessageKit.SenderType {
        return Sender(senderId: currentUser?.id ?? UUID().uuidString,
                      displayName: currentUser?.userName ?? "defaultName")
    }
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Lifecycles
    
    init(coordinator: ChatTabCoordinator, channel: Channel) {
        self.coordinator = coordinator
        
    }
    
    // MARK: - API
    
    private func setupListener(by inputObserver: Observable<Channel?>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, channel) in
                guard let channel = owner.channel.value else { return }
                print(#function, "channel: ", channel.id)
                owner.chatAPI.subscribe(id: channel.id)
                    .asObservable()
                    .subscribe { messages in
                        owner.loadImageAndUpdateCells(messages)
                    } onError: { error in
                        print("DEBUG - setupListener Error: \(error.localizedDescription)")
                    }
                    .disposed(by: self.disposeBag)

            })
            .disposed(by: disposeBag)
    }
    
    private func fetchWithUser(by inputObserver: Observable<Void>) {
        
    }
    
    private func fetchChannel(by inputObserver: Observable<Void>) {
        
    }
    
    // MARK: - Helpers
    
//    func transform(_ input: Input) -> Output {
//        
//        return
//    }
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            var message = message
            if let url = message.downloadURL {
                StorageAPI.downloadImage(url: url) { [weak self] image in
                    guard let image = image,
                    let self = self else { return }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        var newMessages = messages.value
        newMessages.append(message)
        newMessages.sort()
        
        // TODO: - ViewController에서 bind에 적용하기
        // messagesCollectionView.reloadData(), messagesCollectionView.scrollToLastItem(animated: false)
    }
    
}
