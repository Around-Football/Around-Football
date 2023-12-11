//
//  DetailCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/17/23.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .detailScene
    var recruitItem: Recruit?
    
    // MARK: - 이동할때 각 DetailView에 Recruit 전해줌. 다른 뷰에서 쓸 수도 있어서 옵셔널
    
    override func start() {
        let viewModel = DetailViewModel(coordinator: self, recruitItem: recruitItem)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
        childCoordinators.append(self)
    }
    
    func popDetailViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
    
    func pushApplicationStatusViewController() {
        let viewModel = ApplicantListViewModel(coordinator: self)
        viewModel.recruitItem = recruitItem
        let controller = ApplicantListViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushChatViewController(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        let coordinator = ChatTabCoordinator(navigationController: navigationController)
        coordinator.pushChatView(channelInfo: channelInfo, isNewChat: isNewChat)
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator() {
        guard let coordinator = childCoordinators.last as? ChatTabCoordinator else {
            print("DEBUG - This Coordinator is not ChatTabCoordinator")
            return
        }
    
        removeThisChildCoordinators(coordinator: coordinator)
    }
}
