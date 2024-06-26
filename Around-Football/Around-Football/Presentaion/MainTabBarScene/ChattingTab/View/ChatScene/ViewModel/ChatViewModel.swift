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
    
    weak var coordinator: ChatCoordinator?
    
    let disposeBag = DisposeBag()
    var channel: BehaviorRelay<Channel?> = BehaviorRelay(value: nil)
    var messages: BehaviorRelay<[Message]> = BehaviorRelay(value: [])
    let channelInfo: ChannelInfo
    var recruit: BehaviorRelay<Recruit?> = BehaviorRelay(value: nil)
    var currentUser: User?
    var withUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
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
    
    init(coordinator: ChatCoordinator?, channelInfo: ChannelInfo, isNewChat: Bool) {
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
        self.messages.accept([])
    }
    
    func fetchReportUser() -> String? {
        return self.withUser.value?.userName
    }
    
    private func fetchWithUser(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, _) in
                FirebaseAPI.shared.fetchUser(uid: owner.channelInfo.withUserId) { user in
                    owner.withUser.accept(user)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchRecruit(by inputObserver: Observable<Void>) -> Observable<Recruit?> {
        return inputObserver
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
                guard let currentUser = owner.currentUser else { return }
                let message = Message(user: currentUser, content: text, messageType: .chat)
                if owner.isNewChat {
                    owner.channelAPI.createChannel(channelInfo: owner.channelInfo) {
                        owner.saveMessage(message: message) {
                            owner.isNewChat = false
                        }
                    }
                } else {
                    owner.saveMessage(message: message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func sendPhoto(by inputObserver: Observable<UIImage>) {
        inputObserver
            .withUnretained(self)
            .subscribe { (owner, image) in
                guard let channel = owner.channel.value else { return }
                owner.isSendingPhoto.accept(true)
                if owner.isNewChat {
                    owner.channelAPI.createChannel(channelInfo: owner.channelInfo) {
                        owner.uploadImage(image: image, channel: channel)
                        owner.isNewChat = false
                    }
                } else {
                    owner.uploadImage(image: image, channel: channel)
                }
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
        StorageAPI.uploadImage(image: image, id: channel.id) { [weak self] url in
            guard let self = self,
                  let currentUser = currentUser,
                  let withUser = withUser.value,
                  let url = url else { return }
            
            isSendingPhoto.accept(false)
            var message = Message(user: currentUser, image: image)
            message.downloadURL = url
            
            // Date 메시지 첨부 전송 여부 로직
            let saveMessages = appendDateMessageCell(message: message)
            
            chatAPI.save(saveMessages) { error in
                if let error = error {
                    print("DEBUG - inputBar Error: \(error.localizedDescription)")
                    return
                }
            }
            
            channelAPI.updateChannelInfo(owner: currentUser,
                                         withUser: withUser,
                                              channelId: channel.id,
                                              message: message)
            
            channelAPI.updateTotalAlarmNumber(uid: withUser.id, alarmNumber: 1) {
                NotiManager.shared.pushChatNotification(channel: channel,
                                                        content: ("사진"),
                                                        receiverFcmToken: withUser.fcmToken,
                                                        to: withUser,
                                                        from: currentUser)
            }
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
                  let withUser = withUser.value,
                  let channel = self.channel.value else { return }
            channelAPI.updateChannelInfo(owner: currentUser,
                                         withUser: withUser,
                                         channelId: channel.id,
                                         message: message)

            channelAPI.updateTotalAlarmNumber(uid: withUser.id, alarmNumber: 1) {
                NotiManager.shared.pushChatNotification(channel: channel,
                                                        content: message.content,
                                                        receiverFcmToken: withUser.fcmToken,
                                                        to: withUser,
                                                        from: currentUser)
            }
            
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
            NotiManager.shared.currentChatRoomId = channelInfo.id
            channelAPI.resetAlarmNumber(uid: currentUser.id, channelId: channelInfo.id) {
                FirebaseAPI.shared.fetchUser(uid: currentUser.id) { user in
                    guard let user = user else { return }
                    UserService.shared.currentUser_Rx.onNext(user)
                    NotiManager.shared.setAppIconBadgeNumber(number: user.totalAlarmNumber)
                }
            }
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
