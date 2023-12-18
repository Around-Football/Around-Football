//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

import Firebase
import FirebaseAuth
import MessageKit
import RxSwift
import RxRelay

final class ChatViewModel {
    
    // MARK: - Properties
    
    var coordinator: ChatCoordinatorProtocol?
    
    let disposeBag = DisposeBag()
    var channel: BehaviorRelay<Channel?> = BehaviorRelay(value: nil)
    var messages: BehaviorRelay<[Message]> = BehaviorRelay(value: [])
    let channelInfo: ChannelInfo
    var recruit: BehaviorRelay<Recruit?> = BehaviorRelay(value: nil)
    var currentUser: User?
    var withUser: User? = nil
    var isSendingPhoto: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isNewChat: Bool
    
    private let chatAPI = ChatAPI.shared
    private let channelAPI = ChannelAPI.shared
    
    var currentSender: MessageKit.SenderType {
        return Sender(senderId: currentUser?.id ?? UUID().uuidString,
                      displayName: currentUser?.userName ?? "defaultName")
    }
    
    struct Input {
        let didTapSendButton: Observable<String>
        let pickedImage: Observable<UIImage>
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let recruitStatus: Observable<Recruit?>
    }
    
    // MARK: - Lifecycles
    
    init(coordinator: ChatCoordinatorProtocol, channelInfo: ChannelInfo, isNewChat: Bool) {
        self.coordinator = coordinator
        self.channelInfo = channelInfo
        self.isNewChat = isNewChat
        self.channel.accept(Channel(id: channelInfo.id, isAvailable: channelInfo.isAvailable))
        
        UserService.shared.currentUser_Rx
            .subscribe { [weak self] user in
                guard let self else { return }
                currentUser = user
            }.dispose()
    }
    
    // MARK: - API
    
    private func setupChatListener(by inputObserver: Observable<Void>) {
        inputObserver
            .take(1)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                print(#function, "channel: ", owner.channelInfo.id)
                owner.chatAPI.chatSubscribe(id: owner.channelInfo.id)
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
    
    private func setupChatStatusListener(by inputObserver: Observable<Void>) {
        inputObserver
            .take(1)
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.chatAPI.chatStatusSubscribe(id: owner.channelInfo.id) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let channel): self.channel.accept(channel)
                    case .failure(let error): print("DEBUG - ", #function, error.localizedDescription)
                    }
                }
            } onError: { error in
                print("DEBUG - setupStatusListener Error: \(error.localizedDescription)")
            }
            .disposed(by: self.disposeBag)
    }
    
    func removeListener() {
        chatAPI.removeChatListener()
        chatAPI.removeChatStatusListener()
    }
    
    private func fetchWithUser(by inputObserver: Observable<Void>) {
        inputObserver
            .take(1)
            .withUnretained(self)
            .subscribe { (owner, _) in
                FirebaseAPI.shared.fetchUser(uid: owner.channelInfo.withUserId) { user in
                    owner.withUser = user
                    print("withUser: \(String(describing: owner.withUser))")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchRecruit(by inputObserver: Observable<Void>) -> Observable<Recruit?> {
        return inputObserver
            .take(1)
            .flatMap { _ in
                return Observable<Recruit?>.create { observe in
                    FirebaseAPI.shared.fetchRecruit(recruitID: self.channelInfo.recruitID) { [weak self] recruit, error  in
                        guard let self = self else { return }
                        
                        if let error = error {
                            observe.onError(error)
                        }
                        self.recruit.accept(recruit)
                        observe.onNext(recruit)
                    }
                    return Disposables.create()
                }
            }
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        setupChatListener(by: input.invokedViewWillAppear)
        setupChatStatusListener(by: input.invokedViewWillAppear)
        fetchWithUser(by: input.invokedViewWillAppear)
        let recruitStatus = fetchRecruit(by: input.invokedViewWillAppear)
        sendMessage(by: input.didTapSendButton)
        sendPhoto(by: input.pickedImage)
        return Output(recruitStatus: recruitStatus)
    }
    
    private func sendMessage(by inputObserver: Observable<String>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, text) in
                print(#function)
                guard let currentUser = owner.currentUser else { return }
                let message = Message(user: currentUser, content: text, messageType: .chat)
                if owner.isNewChat {
                    print("isNewChat = \(owner.isNewChat)")
                    owner.channelAPI.createChannel(channelInfo: owner.channelInfo) {
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
                guard let currentUser = owner.currentUser,
                      let withUser = owner.withUser,
                      let channel = owner.channel.value else { return }
                owner.isSendingPhoto.accept(true)
                if owner.isNewChat {
                    print("isNewChat = \(owner.isNewChat)")
                    owner.channelAPI.createChannel(channelInfo: owner.channelInfo) {
                        owner.uploadImage(image: image, channel: channel)
                        owner.isNewChat = false
                    }
                } else {
                    owner.uploadImage(image: image, channel: channel)
                }
                NotiManager.shared.pushNotification(channel: channel,
                                                    content: ("사진"),
                                                    receiverFcmToken: withUser.fcmToken,
                                                    from: currentUser)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            var message = message
            if let url = message.downloadURL {
                StorageAPI.downloadImage(url: url) { [weak self] image in
                    guard let self = self else { return }
                    
                    if let image = image {
                        message.image = image
                    } else {
                        message.image = UIImage(systemName: "xmark.circle")
                    }
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        var messages: [Message] = self.messages.value
        guard let firstMessage = self.messages.value.first else {
            messages.append(message)
            self.messages.accept(messages)
            return
        }
        var standardMessage = firstMessage
        messages.append(message)
        messages.sort()
        
        for i in 1..<messages.count {
            if Calendar.current.isDate(standardMessage.sentDate,
                                       equalTo: messages[i].sentDate,
                                       toGranularity: .minute)
                &&
                standardMessage.sender.senderId == messages[i].sender.senderId {
                messages[i - 1].showTimeLabel = false
            } else {
                messages[i - 1].showTimeLabel = true
            }
            standardMessage = messages[i]
        }
        
        messages[messages.count - 1].showTimeLabel = true
        self.messages.accept(messages)
    }
    
    private func uploadImage(image: UIImage, channel: Channel) {
        StorageAPI.uploadImage(image: image, channel: channel) { [weak self] url in
            guard let self = self,
                  let currentUser = currentUser,
                  let withUser = withUser,
                  let url = url else { return }
            
            self.isSendingPhoto.accept(false)
            var message = Message(user: currentUser, image: image)
            message.downloadURL = url
            
            // Date 메시지 첨부 전송 여부 로직
            let saveMessages = appendDateMessageCell(message: message)
            
            self.chatAPI.save(saveMessages) { error in
                if let error = error {
                    print("DEBUG - inputBar Error: \(error.localizedDescription)")
                    return
                }
            }
            
            self.channelAPI.updateChannelInfo(owner: currentUser,
                                              withUser: withUser,
                                              channelId: channel.id,
                                              message: message)
        }
    }
    
    private func saveMessage(message: Message, completion: (() -> Void)? = nil) {
        // Date 메시지 첨부 전송 여부 로직
        let saveMessages = appendDateMessageCell(message: message)
        
        chatAPI.save(saveMessages) { [weak self] error in
            if let error = error {
                print("DEBUG - inputBar Error: \(error.localizedDescription)")
                return
            }
            guard let self = self,
                  let currentUser = currentUser,
                  let withUser = withUser,
                  let channel = self.channel.value else { return }
            channelAPI.updateChannelInfo(owner: currentUser,
                                         withUser: withUser,
                                         channelId: channel.id,
                                         message: message)
            NotiManager.shared.pushNotification(channel: channel,
                                                content: message.content,
                                                receiverFcmToken: withUser.fcmToken,
                                                from: currentUser)
            
            completion?()
        }
    }
    
    private func appendDateMessageCell(message: Message) -> [Message] {
        var saveMessages = [message]
        let dateMessage = Message(user: currentUser!, content: "", messageType: .date)
        let lastMessage = messages.value.last
        if messages.value.isEmpty {
            saveMessages.append(dateMessage)
        } else if !Calendar.current.isDate(message.sentDate, equalTo: lastMessage!.sentDate, toGranularity: .day) {
            saveMessages.append(dateMessage)
        }
        return saveMessages
    }
    
    func resetAlarmInformation() {
        if let currentUser = self.currentUser {
            channelAPI.resetAlarmNumber(uid: currentUser.id, channelId: channelInfo.id)
            NotiManager.shared.currentChatRoomId = channelInfo.id
        }
    }
    
    func showDetailRecruitView() {
        guard let recruit = recruit.value else { return }
        coordinator?.pushToDetailView(recruitItem: recruit)
    }
    
    func showPHPickerView(picker: UIViewController) {
        coordinator?.presentPHPickerView(picker: picker)
    }
}
