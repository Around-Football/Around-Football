//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift
import RxRelay

class ChatViewModel {
    
    weak var coordinator: ChatTabCoordinator?
    
    let channel = Channel(id: "", members: 2) // 수정
    var messages: [Message] = []
    let chatAPI = ChatAPI.shared
    let channelAPI = ChannelAPI.shared
    let currentUser: User? = nil
    let withUser: User? = nil
    var isNewChat: Bool = false
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
//        let currentUser: Observable<User?>
        let isShowing: Observable<Bool>
    }

    init(coordinator: ChatTabCoordinator) {
        self.coordinator = coordinator
    }
}
