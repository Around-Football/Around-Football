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

final class ChatTabCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .chat
    var delegate: ChatTabCoordinatorDelegate?
    
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
        print("ChatTabCoordinator함수")
        let viewModel = ChatViewModel(coordinator: self, channelInfo: channelInfo, isNewChat: isNewChat)
        let controller = ChatViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentPHPickerView(picker: UIViewController) {
        navigationController?.present(picker, animated: true)
    }
    
    func presentDeleteAlertController(alert: UIAlertController) {
        navigationController?.present(alert, animated: true)
    }
      
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func popCurrnetPage() {
        navigationController?.popViewController(animated: true)
    }
}
