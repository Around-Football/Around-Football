//
//  ChatCoordinator.swift
//  Around-Football
//
//  Created by 진태영 on 12/19/23.
//

import UIKit

final class ChatCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .chatScene
    
    deinit {
        print("DEBUG: ChatCoordinator deinit")
    }
    
    func start(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        let viewModel = ChatViewModel(coordinator: self, channelInfo: channelInfo, isNewChat: isNewChat)
        let controller = ChatViewController(viewModel: viewModel)
        let AFBackButton = UIBarButtonItem(image: UIImage(named: AFIcon.backButton), style: .plain, target: self, action: #selector(popChatViewController))
        AFBackButton.tintColor = AFColor.grayScale200
        controller.navigationItem.setLeftBarButton(AFBackButton, animated: true)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //메세지 관련
    func presentPHPickerView(picker: UIViewController) {
        navigationController?.present(picker, animated: true)
    }
    
    @objc
    func popChatViewController() {
        navigationController?.popViewController(animated: true)
        deinitCoordinator()
    }
    
    func pushToDetailView(recruitItem: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        navigationController?.navigationBar.isHidden = false
        coordinator.start(recruitItem: recruitItem)
        childCoordinators.append(coordinator)
    }
}
