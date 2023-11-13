//
//  ChatTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol ChatTabCoordinatorDelegate {
    //
}

final class ChatTabCoordinator: BaseCoordinator, ChatViewControllerDelegate {
    
    var type: CoordinatorType = .chat
    var delegate: ChatTabCoordinatorDelegate?
    
    deinit {
        print("DEBUG: ChatTabCoordinator deinit")
    }
    
    func makeChatViewController() -> UINavigationController {
        let chatViewModel = ChatViewModel(coordinator: self)
        let chatViewController = ChatViewController(delegate: self, viewModel: chatViewModel)
        navigationController = UINavigationController(rootViewController: chatViewController)
        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
}
