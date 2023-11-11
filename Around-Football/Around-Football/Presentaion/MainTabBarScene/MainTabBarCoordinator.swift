//
//  MainTabBarCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol MainTabBarCoordinatorDelegate {
    func presentLoginViewController()
}

final class MainTabBarCoordinator: BaseCoordinator,
                                    HomeTabCoordinatorDelegate,
                                    InfoTabCoordinatorDelegate,
                                   ChatTabCoordinatorDelegate {

    var type: CoordinatorType = .mainTab
    var delegate: MainTabBarCoordinatorDelegate?
    
    override func start() {
        showMainTabController()
    }
    
    deinit {
        print("DEBUG: MainTabBarCoordinator deinit")
    }
    
    private func showMainTabController() {
        navigationController?.isNavigationBarHidden = true
        let homeViewController = makeHomeViewController()
        let mapViewController = makeMapViewController()
        let channelViewController = makeChannelViewController()
        let infoViewController = makeInfoViewController()
        
        makeMainTabBarController(homeVC: homeViewController,
                                 mapVC: mapViewController,
                                 chatVC: channelViewController,
                                 infoVC: infoViewController)
    }
    
    //TODO: - 각 Coordinator 마다 delegate = self로 설정
    //TODO: - Controller delegate도 여기서 선언
    private func makeHomeViewController() -> UINavigationController {
        let homeViewController = HomeViewController()

        let homeNavigationController: UINavigationController = makeNavigationController(
            rootViewController: homeViewController,
            title: "Home",
            tabbarImage: "house",
            tag: 0
        )

        let homeTabCoordinator = HomeTabCoordinator(navigationController: homeNavigationController)
        homeViewController.delegate = homeTabCoordinator
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
    
    private func makeChannelViewController() -> UINavigationController {
        let channelViewController = ChannelViewController(viewModel: ChannelViewModel())
        let channelNavigationController: UINavigationController = makeNavigationController(
            rootViewController: channelViewController,
            title: "Chat",
            tabbarImage: "bubble",
            tag: 2
        )
        
        let chatTabCoordinator = ChatTabCoordinator(navigationController: channelNavigationController)
        childCoordinators.append(chatTabCoordinator)
        chatTabCoordinator.start()
        
        return channelNavigationController
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
        infoTabCoordinator.delegate = self
        infoViewController.loginViewModel = LoginViewModel()
        infoViewController.delegate = infoTabCoordinator
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
    
    // HomeTabCoordinatorDelegate
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
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
