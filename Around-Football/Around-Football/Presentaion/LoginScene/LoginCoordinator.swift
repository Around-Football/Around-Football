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

final class LoginCoordinator: BaseCoordinator, LoginViewControllerDelegate {

    var type: CoordinatorType = .login
    var delegate: LoginCoordinatorDelegate?
    var loginNavigationViewController: UINavigationController?
    
    override func start() {
        let controller = LoginViewController()
        controller.viewModel = LoginViewModel()
        controller.delegate = self
        //기존 로그인뷰 뜸
        //        navigationController?.viewControllers = [loginViewController]
        // MARK: - 모달로 변경, 로그인뷰 안에서만 사용하는 네비게이션 컨트롤러인 loginNavigationViewController 추가
        loginNavigationViewController = UINavigationController(rootViewController: controller)
        if let loginNavigationViewController {
            navigationController?.present(loginNavigationViewController, animated: true)
        }
    }
    
    deinit {
        print("DEBUG: LoginCoordinator deinit")
    }
    
    func pushToInputInfoView() {
        let inputInfoCoordinator = InputInfoCoordinator(navigationController: loginNavigationViewController)
        inputInfoCoordinator.start()
        childCoordinators.append(inputInfoCoordinator)
    }
    
    //LoginViewControllerDelegate
    func pushToInputInfoViewController() {
        print("pushToInputInfoViewController 실행")
        pushToInputInfoView()
    }
    
    func showMainTabController() {
        delegate?.showMainTabController()
        removeFromChildCoordinators(coordinator: self)
    }
    
}
