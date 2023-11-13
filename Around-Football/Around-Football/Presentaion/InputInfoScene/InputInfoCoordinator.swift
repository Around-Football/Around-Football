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

final class InputInfoCoordinator: BaseCoordinator
//                                  InputInfoViewControllerDelegate
{
    var type: CoordinatorType = .login
    var delegate: InputInfoCoordinatorDelegate?
    
    override func start() {
        start(isHidesBackButton: false)
    }
    
    func start(isHidesBackButton: Bool) {
        let inputInfoViewModel = InputInfoViewModel(coordinator: self)
        let controller = InputInfoViewController(viewModel: inputInfoViewModel)
//        controller.delegate = self
        controller.navigationItem.hidesBackButton = isHidesBackButton
        navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("DEBUG: InputInfoCoordinator deinit")
    }
    
    func dismissView() {
        navigationController?.dismiss(animated: true)
    }
    
    func removeThisChildCoordinators() {
        removeThisChildCoordinators(coordinator: self)
    }
}
