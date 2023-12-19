//
//  MainTabBarCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {

    var type: CoordinatorType = .mainTab
    var homeTabCoordinator = HomeTabCoordinator()
    var mapTabCoordinator = MapTabCoordinator()
    var chatTabCoordinator = ChatTabCoordinator()
    var infoTabCoordinator = InfoTabCoordinator()

    override func start() {
        showMainTabController()
    }
    
    deinit {
        print("DEBUG: MainTabBarCoordinator deinit")
    }
    
    private func showMainTabController() {
        navigationController?.isNavigationBarHidden = true
        // MARK: - navigationController 내부에서 새로 만들어줌
        
        childCoordinators.append(homeTabCoordinator)
        childCoordinators.append(mapTabCoordinator)
        childCoordinators.append(chatTabCoordinator)
        childCoordinators.append(infoTabCoordinator)
        
        let homeViewController = homeTabCoordinator.makeHomeViewController()
        let mapViewController = mapTabCoordinator.makeMapViewController()
        let channelViewController = chatTabCoordinator.makeChannelViewController()
        let infoViewController = infoTabCoordinator.makeInfoViewController()

        makeMainTabBarController(homeVC: homeViewController,
                                 mapVC: mapViewController,
                                 chatVC: channelViewController,
                                 infoVC: infoViewController)
    }

    private func makeMainTabBarController(
        homeVC: UINavigationController,
        mapVC: UINavigationController,
        chatVC: UINavigationController,
        infoVC: UINavigationController
    ) {
        let viewModel = MainTabViewModel()
        let mainTabBarController = MainTabController(viewModel: viewModel,
                                                     pages: [homeVC, mapVC, chatVC, infoVC])
        navigationController?.viewControllers = [mainTabBarController]
    }
        
    func pushToDetailView(recruit: Recruit) {
    }
    
    func handleChatDeepLink(channelInfo: ChannelInfo) {
        guard let mainTabController = navigationController?.viewControllers.first as? MainTabController,
              let selectedCoordinator = childCoordinators.first(where: { $0 is ChatTabCoordinator }) as? ChatTabCoordinator,
              let navigationController = selectedCoordinator.navigationController else { return }
        if navigationController.viewControllers.count > 1 {
            navigationController.viewControllers.removeSubrange(1...)
        }
        selectedCoordinator.deinitChildCoordinator()
        mainTabController.selectedIndex = 2
        selectedCoordinator.pushChatView(channelInfo: channelInfo)
    }
}
