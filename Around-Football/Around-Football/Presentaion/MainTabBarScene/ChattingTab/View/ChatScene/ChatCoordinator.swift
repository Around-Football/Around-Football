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
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //메세지 관련
    func presentPHPickerView(picker: UIViewController) {
        navigationController?.present(picker, animated: true)
    }
    
    func popCurrnetPage() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushToDetailView(recruitItem: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        navigationController?.navigationBar.isHidden = false
        coordinator.start(recruitItem: recruitItem)
        childCoordinators.append(coordinator)
    }
    
    func deinitChildCoordinator() {
        super.deinitCoordinator()
    }
}
