//
//  DetailCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/17/23.
//

import UIKit

protocol DetailCoordinatorDelegate {
    func presentLoginViewController()
}

final class DetailCoordinator: BaseCoordinator, ChatCoordinatorProtocol {
    
    var type: CoordinatorType = .detailScene
    var delegate: MainTabBarCoordinatorDelegate?
    
    // MARK: - 이동할때 각 DetailView에 Recruit 전해줌. 다른 뷰에서 쓸 수도 있어서 옵셔널
    
    func start(recruitItem: Recruit) {
        let viewModel = DetailViewModel(coordinator: self, recruitItem: recruitItem)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
        childCoordinators.append(self)
    }
    
    func popDetailViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
    
    func pushApplicationStatusViewController(recruit: Recruit) {
        let viewModel = ApplicantListViewModel(coordinator: self)
        viewModel.recruitItem = recruit
        let controller = ApplicantListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    func pushChatViewController(channelInfo: ChannelInfo, isNewChat: Bool = false) {
//        let coordinator = ChatTabCoordinator(navigationController: navigationController)
//        coordinator.pushChatView(channelInfo: channelInfo, isNewChat: isNewChat)
//        childCoordinators.append(coordinator)
//    }
    
    func clickSendMessageButton(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        if navigationController?.viewControllers.first(where: { $0 is ChatViewController }) != nil {
            navigationController?.popViewController(animated: true)
            removeThisChildCoordinators(coordinator: self)
        } else {
            self.pushChatView(channelInfo: channelInfo, isNewChat: isNewChat)
        }
    }
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func removeChildCoordinator() {
        guard let coordinator = childCoordinators.last as? ChatTabCoordinator else {
            print("DEBUG - This Coordinator is not ChatTabCoordinator")
            return
        }
    
        removeThisChildCoordinators(coordinator: coordinator)
    }
}
