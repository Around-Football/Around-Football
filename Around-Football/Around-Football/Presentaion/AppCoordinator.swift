//
//  AppCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

enum CoordinatorType {
    case app
    case login
    case mainTab
    case home
    case map
    case chat
    case info
    case detailScene
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
}

//Coordinator 프로토콜 채택한 공통 BaseCoordinator 클래스
class BaseCoordinator: Coordinator {

    // MARK: - Property
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: - Start

    func start() {}
    
    func removeFromChildCoordinators(coordinator: Coordinator) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
}

final class AppCoordinator: BaseCoordinator, LoginCoordinatorDelegate, MainTabBarCoordinatorDelegate {
    
    var type: CoordinatorType = .app
    
    override func start() {
        showMainTabController()
//        showLoginViewController() //Test
    }
    
    func showMainTabController() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start() //뷰컨 생성 후 이동
        childCoordinators.append(coordinator)
    }
    
    func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
