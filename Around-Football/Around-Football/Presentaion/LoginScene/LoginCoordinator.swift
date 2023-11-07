//
//  LoginCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol LoginCoordinatorDelegate {
    func showMainTabController()
}

final class LoginCoordinator: BaseCoordinator, LoginViewControllerDelegate, InputInfoCoordinatorDelegate {

    var type: CoordinatorType = .login
    var delegate: LoginCoordinatorDelegate?
    var loginNavigationViewController: UINavigationController? //로그인 뷰 내에서만 사용하는 네비게이션 뷰컨
    
    override func start() {
        let controller = LoginViewController()
        controller.viewModel = LoginViewModel()
        controller.delegate = self
        loginNavigationViewController = UINavigationController(rootViewController: controller)
        if let loginNavigationViewController {
            navigationController?.present(loginNavigationViewController, animated: true)
        }
    }
    
    deinit {
        print("DEBUG: LoginCoordinator deinit")
    }
    
    //LoginCoordinatorDelegate
    func showMainTabController() {
        delegate?.showMainTabController()
        removeThisChildCoordinators(coordinator: self)
    }
    
    //LoginViewControllerDelegate
    func pushInputInfoViewController() {
        let inputInfoCoordinator = InputInfoCoordinator(navigationController: loginNavigationViewController)
        inputInfoCoordinator.start()
        inputInfoCoordinator.delegate = self
        childCoordinators.append(inputInfoCoordinator)
    }
    
    //InputInfoCoordinatorDelegate
    func loginDone() {
        removeThisChildCoordinators(coordinator: self)
    }
    
}
