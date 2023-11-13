//
//  ChatTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol ChatTabCoordinatorDelegate {
    func presentLoginViewController()
}

final class ChatTabCoordinator: BaseCoordinator, ChannelViewControllerDelegate {

    var type: CoordinatorType = .chat
    var delegate: ChatTabCoordinatorDelegate?
    
    deinit {
        print("DEBUG: ChatTabCoordinator deinit")
    }
      
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func pushChatView() {
        let controller = ChatViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func popCurrnetPage() {
        navigationController?.popViewController(animated: true)
    }
}
