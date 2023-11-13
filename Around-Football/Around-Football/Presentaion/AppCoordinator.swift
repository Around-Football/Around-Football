//
//  AppCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

/* Coordinator 함수 이름
 1. 화면 그냥 띄워줄때 show이름ViewController
 2. 화면 네비게이션으로 이동할때 push이름ViewController
 3. 화면 네비게이션으로 돌아갈때 pop이름ViewController
 4. 모달로 띄울때 present이름ViewController
 5. 모달로 내릴때 dismissView
 */

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
    var childCoordinators: [Coordinator] { get set } // 자식 코디네이터 가지고 있음.
    var navigationController: UINavigationController? { get set }
    
    func start() // 뷰컨트롤러 만들고 그 뷰컨으로 이동
}

// Coordinator 프로토콜 채택한 공통 BaseCoordinator 클래스
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
    
    func removeThisChildCoordinators(coordinator: Coordinator) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
}

final class AppCoordinator: BaseCoordinator, LoginCoordinatorDelegate, MainTabBarCoordinatorDelegate {
    
    var type: CoordinatorType = .app
    
    override func start() {
        showMainTabController()
    }
    
    func showMainTabController() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start() // 뷰컨 생성 후 이동
        childCoordinators.append(coordinator)
    }
    
    //TODO: - 온보딩뷰 컨트롤러 올리기
    func presentLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }
}
