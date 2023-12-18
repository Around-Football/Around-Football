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

final class ChatTabCoordinator: BaseCoordinator, ChatCoordinatorProtocol, MainTabBarCoordinatorDelegate {
    
    var type: CoordinatorType = .chat
    var delegate: MainTabBarCoordinatorDelegate?
    
    deinit {
        print("DEBUG: ChatTabCoordinator deinit")
    }
    
    func makeChannelViewController() -> UINavigationController {
        let channelViewModel = ChannelViewModel(coordinator: self)
        let channelViewController = ChannelViewController(viewModel: channelViewModel)
        navigationController = UINavigationController(rootViewController: channelViewController)
        navigationController?.navigationBar.isHidden = false
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
      
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func popCurrnetPage() {
        navigationController?.popViewController(animated: true)
    }
}
