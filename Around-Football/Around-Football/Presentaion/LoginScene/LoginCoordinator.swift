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

final class LoginCoordinator: BaseCoordinator, InputInfoCoordinatorDelegate {

    var type: CoordinatorType = .login
    var delegate: LoginCoordinatorDelegate?
    var loginNavigationViewController: UINavigationController? //로그인 뷰 내에서만 사용하는 네비게이션 뷰컨
    
    override func start() {
        let loginViewModel = LoginViewModel(coordinator: self)
        let controller = LoginViewController(viewModel: loginViewModel)
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
        inputInfoCoordinator.start(isHidesBackButton: true)
        inputInfoCoordinator.delegate = self
        childCoordinators.append(inputInfoCoordinator)
    }
    
    //InputInfoCoordinatorDelegate
    func loginDone() {
        navigationController?.dismiss(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
}
