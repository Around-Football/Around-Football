//
//  DetailCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/17/23.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .detailScene
    
    // MARK: - 이동할때 각 DetailView에 Recruit 전해줌. 다른 뷰에서 쓸 수도 있어서 옵셔널
    func start(recruitItem: Recruit) {
        let viewModel = DetailViewModel(coordinator: self, recruitItem: recruitItem)
        let controller = DetailViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func popDetailViewController() {
        navigationController?.popViewController(animated: true)
        deinitCoordinator()
    }
    
    func pushApplicationStatusViewController(recruit: Recruit) {
        if let viewController = navigationController?.viewControllers.first(where: { $0 is ApplicantListViewController }) {
            navigationController?.popToViewController(viewController, animated: true)
            removeThisChildCoordinators(coordinator: self)
        } else {
            let viewModel = ApplicantListViewModel(coordinator: self, recruit: recruit)
            let controller = ApplicantListViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func deepLinkApplicationViewController(recruit: Recruit) {
        let viewModel = DetailViewModel(coordinator: self, recruitItem: recruit)
        let controller = DetailViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: false)
        pushApplicationStatusViewController(recruit: recruit)
    }
        
    func clickSendMessageButton(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        if navigationController?.viewControllers.first(where: { $0 is ChatViewController }) != nil {
            navigationController?.popViewController(animated: true)
            removeThisChildCoordinators(coordinator: self)
        } else {
            let coordinator = ChatCoordinator(navigationController: navigationController)
            coordinator.start(channelInfo: channelInfo, isNewChat: isNewChat)
            childCoordinators.append(coordinator)
        }
    }
    
    func presentLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }

    func removeChatCoordinator() {
        guard let coordinator = childCoordinators.last as? ChatCoordinator else {
            print("DEBUG - This Coordinator is not ChatTabCoordinator")
            return
        }
    
        removeThisChildCoordinators(coordinator: coordinator)
    }
}
