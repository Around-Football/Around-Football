//
//  ChatTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class ChatTabCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .chat
    
    deinit {
        print("DEBUG: ChatTabCoordinator deinit")
    }
    
    func makeChannelViewController() -> UINavigationController {
        let channelViewModel = ChannelViewModel(coordinator: self)
        let channelViewController = ChannelViewController(viewModel: channelViewModel)
        navigationController = UINavigationController(rootViewController: channelViewController)
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    //메세지 관련
    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        let coordinator = ChatCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start(channelInfo: channelInfo, isNewChat: isNewChat)
    }
    
    func presentDeleteAlertController(alert: UIAlertController) {
        navigationController?.present(alert, animated: true)
    }
    
    func presentLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }
}
