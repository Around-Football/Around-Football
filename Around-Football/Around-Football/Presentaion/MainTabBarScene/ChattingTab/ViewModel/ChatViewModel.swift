//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import Firebase
import FirebaseAuth
import MessageKit
import RxSwift
import RxRelay

final class ChatViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: ChatTabCoordinator?
    
    let disposeBag = DisposeBag()
    var channel: BehaviorRelay<Channel?> = BehaviorRelay(value: nil)
    var messages: BehaviorRelay<[Message]> = BehaviorRelay(value: [])
    let channelInfo: ChannelInfo
    var currentUser: User?
    var withUser: User? = nil
    var isSendingPhoto: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isNewChat: Bool = false
    
    private let chatAPI = ChatAPI.shared
    private let channelAPI = ChannelAPI.shared
    
    var currentSender: MessageKit.SenderType {
        return Sender(senderId: currentUser?.id ?? UUID().uuidString,
                      displayName: currentUser?.userName ?? "defaultName")
    }
    
    struct Input {
        let didTapSendButton: Observable<String>
        let pickedImage: Observable<UIImage>
    }
    
    struct Output {
    }
    
    // MARK: - Lifecycles
    
    init(coordinator: ChatTabCoordinator, channelInfo: ChannelInfo) {
        self.coordinator = coordinator
        self.channelInfo = channelInfo
        self.channel.accept(Channel(id: channelInfo.id, members: 2))
        
        // MARK: - value 옵저버블로 변경
        UserService.shared.currentUser_Rx
            .subscribe { [weak self] user in
                guard let self else { return }
                currentUser = user
        }.dispose()
    }
    
    // MARK: - API
    
    private func setupListener() {
        channel
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                print(#function, "channel: ", owner.channelInfo.id)
                owner.chatAPI.subscribe(id: owner.channelInfo.id)
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
    
    func removeListener() {
        chatAPI.removeListenr()
    }
    
    private func fetchWithUser() {
        channel
            .withUnretained(self)
            .subscribe { (owner, _) in
                FirebaseAPI.shared.fetchUser(uid: owner.channelInfo.withUserId) { user in
                    owner.withUser = user
                    print("withUser: \(String(describing: owner.withUser))")
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        setupListener()
        fetchWithUser()
        sendMessage(by: input.didTapSendButton)
        sendPhoto(by: input.pickedImage)
        return Output()
    }
    
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
//        var newMessages = messages.value
//        newMessages.append(message)
        updateShowTimeLabel(updateMessage: message)
//        newMessages.sort()
//        messages.accept(newMessages)
    }
    
    func updateShowTimeLabel(updateMessage: Message) {
        var messages: [Message] = self.messages.value
        messages.append(updateMessage)
        for i in 0..<messages.count {
            let previousMessage: Message? = i > 0 ? messages[i - 1] : nil
            if let previousMessage = previousMessage,
                Calendar.current.isDate(messages[i].sentDate, equalTo: previousMessage.sentDate, toGranularity: .minute)
                && messages[i].sender.senderId == previousMessage.sender.senderId {
                messages[i - 1].showTimeLabel = false
            } else {
                messages[i].showTimeLabel = true
            }
        }
        messages.sort()
        self.messages.accept(messages)
    }

    
    private func sendMessage(by inputObserver: Observable<String>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, text) in
                print(#function)
                guard let currentUser = owner.currentUser,
                        let channel = owner.channel.value,
                      let withUser = owner.withUser else { return }
                let message = Message(user: currentUser, content: text)
                if owner.isNewChat {
                    print("isNewChat = \(owner.isNewChat)")
                    owner.channelAPI.createChannel(channel: channel, owner: currentUser, withUser: withUser) {
                        owner.saveMessage(message: message) {
                            owner.isNewChat = false
                        }
                    }
                } else {
                    print("isNewChat = \(owner.isNewChat)")
                    owner.saveMessage(message: message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func sendPhoto(by inputObserver: Observable<UIImage>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, image) in
                guard let channel = owner.channel.value,
                        let currentUser = owner.currentUser,
                      let withUser = owner.withUser else { return }
                owner.isSendingPhoto.accept(true)
                StorageAPI.uploadImage(image: image, channel: channel) { url in
                    owner.isSendingPhoto.accept(false)
                    guard let url = url else { return }
                    var message = Message(user: currentUser, image: image)
                    message.downloadURL = url
                    owner.chatAPI.save(message)
                    owner.channelAPI.updateChannelInfo(owner: currentUser,
                                                       withUser: withUser,
                                                       channelId: channel.id,
                                                       message: message)
                    // TODO: - NotiManager 적용
                    //            NotiManager.shared.pushNotification(channel: channel, content: ("사진"), fcmToken: toUser!.fcmToken, from: user)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func saveMessage(message: Message, completion: (() -> Void)? = nil) {
        chatAPI.save(message) { [weak self] error in
            if let error = error {
                print("DEBUG - inputBar Error: \(error.localizedDescription)")
                return
            }
            guard let self = self,
                    let channel = channel.value,
                  let currentUser = currentUser,
                  let withUser = withUser else { return }
            channelAPI.updateChannelInfo(owner: currentUser,
                                         withUser: withUser,
                                         channelId: channel.id,
                                         message: message)
            // TODO: - NotiManagaer
            //                NotiManager.shared.pushNotification(channel: channel, content: text, fcmToken: toUser!.fcmToken, from: user)
            
            completion?()
        }
    }
    
    func showPHPickerView(picker: UIViewController) {
        coordinator?.presentPHPickerView(picker: picker)
    }
}
