//
//  DeepLinkCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/12/23.
//

import UIKit

//ChatCoordinator 추상화
protocol ChatCoordinatorProtocol: MainTabBarCoordinatorDelegate {
    var navigationController: UINavigationController? { get }
    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool)
    func presentPHPickerView(picker: UIViewController)
    func presentDeleteAlertController(alert: UIAlertController)
    func presentLoginViewController()
    func pushToDetailView(recruitItem: Recruit)
}

//chatProtocol 중복 메서드 기본구현
extension ChatCoordinatorProtocol {
    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        let viewModel = ChatViewModel(coordinator: self, channelInfo: channelInfo, isNewChat: isNewChat)
        let controller = ChatViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
    func presentPHPickerView(picker: UIViewController) {
        navigationController?.present(picker, animated: true)
    }
    
    func presentDeleteAlertController(alert: UIAlertController) {
        navigationController?.present(alert, animated: true)
    }
    
    func pushToDetailView(recruitItem: Recruit) {
        if navigationController?.viewControllers.first(where: { $0 is DetailViewController }) != nil {
            navigationController?.popViewController(animated: true)
        } else {
            let coordinator = DetailCoordinator(navigationController: navigationController)
            navigationController?.navigationBar.isHidden = false
            coordinator.delegate = self
            coordinator.start(recruitItem: recruitItem)
        }
    }
}

final class DeepLinkCoordinator: BaseCoordinator, ChatCoordinatorProtocol {
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    var type: CoordinatorType = .deepLink
    var chatTabCoordinator: ChatTabCoordinator?
    var delegate: MainTabBarCoordinatorDelegate?
    
    init(navigationController: UINavigationController?, chatTabCoordinator: ChatTabCoordinator?) {
        self.chatTabCoordinator = chatTabCoordinator
        super.init(navigationController: navigationController)
    }
    
    func start(channelInfo: ChannelInfo) {
        guard let mainTabController = navigationController?.viewControllers.first as? MainTabController else { return }
        //채팅 탭으로 이동
        mainTabController.selectedIndex = 2
        pushChatView(channelInfo: channelInfo)
    }
}
