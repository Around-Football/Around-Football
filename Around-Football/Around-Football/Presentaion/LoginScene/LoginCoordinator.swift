//
//  LoginCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

protocol LoginCoordinatorDelegate {
    func showMainTabController()
}

final class LoginCoordinator: BaseCoordinator, LoginViewControllerDelegate, InputInfoCoordinatorDelegate {

    var type: CoordinatorType = .login
    var delegate: LoginCoordinatorDelegate?
    
    override func start() {
        let loginViewController = LoginViewController()
        loginViewController.viewModel = LoginViewModel()
        loginViewController.delegate = self
        //TODO: - Modal로 로그인뷰 변경 이야기해보기
//        loginViewController.modalPresentationStyle = .fullScreen
//        navigationController?.present(loginViewController, animated: true)
        navigationController?.viewControllers = [loginViewController]
    }
    
    deinit {
        print("DEBUG: LoginCoordinator deinit")
    }
    
    func pushToInputInfoView() {
        //TODO: - 뷰랑 뷰컨 합치는 거 이야기해보기
        let inputInfoCoordinator = InputInfoCoordinator(navigationController: navigationController)
        inputInfoCoordinator.delegate = self
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
