//
//  ChatViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

class ChatViewModel {
    
    weak var coordinator: ChatTabCoordinator?
    
    init(coordinator: ChatTabCoordinator) {
        self.coordinator = coordinator
    }
}
