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

final class MainTabBarCoordinator: BaseCoordinator, HomeTabCoordinatorDelegate, InfoTabCoordinatorDelegate {

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
        let homeTabCoordinator = HomeTabCoordinator(navigationController: nil)
        let mapTabCoordinator = MapTabCoordinator(navigationController: nil)
        let chatTabCoordinator = ChatTabCoordinator(navigationController: nil)
        let infoTabCoordinator = InfoTabCoordinator(navigationController: nil)
        
        childCoordinators.append(homeTabCoordinator)
        childCoordinators.append(mapTabCoordinator)
        childCoordinators.append(chatTabCoordinator)
        childCoordinators.append(infoTabCoordinator)
        
        homeTabCoordinator.delegate = self
        infoTabCoordinator.delegate = self

        let homeViewController = homeTabCoordinator.makeHomeViewController()
        let mapViewController = mapTabCoordinator.makeMapViewController()
        let chatViewController = chatTabCoordinator.makeChatViewController()
        let infoViewController = infoTabCoordinator.makeInfoViewController()

        makeMainTabBarController(homeVC: homeViewController,
                                 mapVC: mapViewController,
                                 chatVC: chatViewController,
                                 infoVC: infoViewController)
    }
    
    //TODO: - 각 Coordinator 마다 delegate = self로 설정
    //TODO: - Controller delegate도 여기서 선언
//    private func makeHomeViewController() -> UINavigationController {
//        let homeViewController = HomeViewController()
//
//        let homeNavigationController: UINavigationController = makeNavigationController(
//            rootViewController: homeViewController,
//            title: "Home",
//            tabbarImage: "house",
//            tag: 0
//        )
//
//        let homeTabCoordinator = HomeTabCoordinator(navigationController: homeNavigationController)
//        homeViewController.delegate = homeTabCoordinator
//        homeTabCoordinator.delegate = self
//        homeTabCoordinator.start()
//        childCoordinators.append(homeTabCoordinator)
//        
//        return homeNavigationController
//    }
    
//    private func makeMapViewController() -> UINavigationController {
//        let mapViewController = MapViewController()
//        let mapNavigationController: UINavigationController = makeNavigationController(
//            rootViewController: mapViewController,
//            title: "Map",
//            tabbarImage: "map",
//            tag: 1
//        )
//        
//        let mapTabCoordinator = MapTabCoordinator(navigationController: mapNavigationController)
//        childCoordinators.append(mapTabCoordinator)
//        mapTabCoordinator.start()
//        
//        return mapNavigationController
//    }
    
//    private func makeChatViewController() -> UINavigationController {
//        let chatViewController = ChatViewController()
//        let chatNavigationController: UINavigationController = makeNavigationController(
//            rootViewController: chatViewController,
//            title: "Chat",
//            tabbarImage: "bubble",
//            tag: 2
//        )
//        
//        let chatTabCoordinator = ChatTabCoordinator(navigationController: chatNavigationController)
//        childCoordinators.append(chatTabCoordinator)
//        chatTabCoordinator.start()
//        
//        return chatNavigationController
//    }
    
//    private func makeInfoViewController() -> UINavigationController {
//        let infoViewController = InfoViewController()
//        let infoNavigationController: UINavigationController = makeNavigationController(
//            rootViewController: infoViewController,
//            title: "Info",
//            tabbarImage: "info.square",
//            tag: 3
//        )
//        
//        let infoTabCoordinator = InfoTabCoordinator(navigationController: infoNavigationController)
//        infoTabCoordinator.delegate = self
//        infoViewController.loginViewModel = LoginViewModel()
//        infoViewController.delegate = infoTabCoordinator
//        childCoordinators.append(infoTabCoordinator)
//        infoTabCoordinator.start()
//        
//        return infoNavigationController
//    }
    
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
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    // MARK: - HomeTab FloatingButtonTabbed
    
    func presentInviteView() {
        let controller = UINavigationController(rootViewController: InviteViewController())
        controller.isNavigationBarHidden = false
        navigationController?.present(controller, animated: true)
    }
}
