//
//  MainTabBarCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol MainTabBarCoordinatorDelegate {
    func showLoginViewController()
}

final class MainTabBarCoordinator: BaseCoordinator, HomeTabCoordinatorDelegate {

    var type: CoordinatorType = .mainTab
    var delegate: MainTabBarCoordinatorDelegate?
    
    override func start() {
        showMainTabController()
    }
    
    private func showMainTabController() {
        navigationController?.isNavigationBarHidden = true
        let homeViewController = makeHomeViewController()
        let mapViewController = makeMapViewController()
        let chatViewController = makeChatViewController()
        let infoViewController = makeInfoViewController()
        
        makeMainTabBarController(homeVC: homeViewController,
                                 mapVC: mapViewController,
                                 chatVC: chatViewController,
                                 infoVC: infoViewController)
    }
    
    //TODO: - 각 Coordinator 마다 delegate = self로 설정
    
    private func makeHomeViewController() -> UINavigationController {
        let homeViewController = HomeViewController()
        let homeNavigationController: UINavigationController = makeNavigationController(
            rootViewController: homeViewController,
            title: "Home",
            tabbarImage: "house",
            tag: 0
        )
        
        let homeTabCoordinator = HomeTabCoordinator(navigationController: homeNavigationController)
        homeTabCoordinator.delegate = self
        homeTabCoordinator.start()
        childCoordinators.append(homeTabCoordinator)
        
        return homeNavigationController
    }
    
    private func makeMapViewController() -> UINavigationController {
        let mapViewController = MapViewController()
        let mapNavigationController: UINavigationController = makeNavigationController(
            rootViewController: mapViewController,
            title: "Map",
            tabbarImage: "map",
            tag: 1
        )
        
        let mapTabCoordinator = MapTabCoordinator(navigationController: mapNavigationController)
        childCoordinators.append(mapTabCoordinator)
        mapTabCoordinator.start()
        
        return mapNavigationController
    }
    
    private func makeChatViewController() -> UINavigationController {
        let chatViewController = ChatViewController()
        let chatNavigationController: UINavigationController = makeNavigationController(
            rootViewController: chatViewController,
            title: "Chat",
            tabbarImage: "bubble",
            tag: 2
        )
        
        let chatTabCoordinator = ChatTabCoordinator(navigationController: chatNavigationController)
        childCoordinators.append(chatTabCoordinator)
        chatTabCoordinator.start()
        
        return chatNavigationController
    }
    
    private func makeInfoViewController() -> UINavigationController {
        let infoViewController = InfoViewController()
        let infoNavigationController: UINavigationController = makeNavigationController(
            rootViewController: infoViewController,
            title: "Info",
            tabbarImage: "info.square",
            tag: 3
        )
        
        let infoTabCoordinator = InfoTabCoordinator(navigationController: infoNavigationController)
        childCoordinators.append(infoTabCoordinator)
        infoTabCoordinator.start()
        
        return infoNavigationController
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
    
    //HomeTabCoordinatorDelegate
    func showLoginViewController() {
        delegate?.showLoginViewController()
    }
    
    func pushToInviteView() {
        print("MainTabBarCoordinator - pushToInviteView")
//        let controller = InviteViewController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func makeNavigationController(
        rootViewController rootVC: UIViewController,
        title: String,
        tabbarImage: String,
        tag: Int
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: tabbarImage),
            tag: tag
        )
        
        return navigationController
    }
}
