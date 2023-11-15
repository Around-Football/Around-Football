//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

class ChatViewModel {
    
    weak var coordinator: ChatTabCoordinator?
    
    var messages: [Message] = []
    let chatAPI = ChatAPI.shared
    let channelAPI = ChannelAPI.shared
    let currentUser: User?
    let withUser: User?
    var isNewChat: Bool = false
    
    init(coordinator: ChatTabCoordinator) {
        self.coordinator = coordinator
    }
}
