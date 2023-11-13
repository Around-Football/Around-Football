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
        // MARK: - navigationController 내부에서 새로 만들어줌
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
}
