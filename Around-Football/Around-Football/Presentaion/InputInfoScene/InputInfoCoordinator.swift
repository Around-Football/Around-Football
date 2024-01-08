//
//  InputInfoCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

protocol InputInfoCoordinatorDelegate {
    func loginDone()
}

final class InputInfoCoordinator: BaseCoordinator {
    var type: CoordinatorType = .login
    var delegate: InputInfoCoordinatorDelegate?
    
    override func start() {
        start(isHidesBackButton: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func start(isHidesBackButton: Bool) {
        let inputInfoViewModel = InputInfoViewModel(coordinator: self)
        let controller = InputInfoViewController(viewModel: inputInfoViewModel)
        
        if isHidesBackButton == false {
            controller.setAFBackButton()
        }
        controller.navigationItem.hidesBackButton = isHidesBackButton
        
        childCoordinators.append(self)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("DEBUG: InputInfoCoordinator deinit")
    }
    
    func dismissView() {
        navigationController?.dismiss(animated: true)
        removeThisChildCoordinators()
    }
    
    func popInputInfoViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators()
    }
    
    func removeThisChildCoordinators() {
        removeThisChildCoordinators(coordinator: self)
    }
}
