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

final class InputInfoCoordinator: BaseCoordinator, InputInfoViewControllerDelegate {
    var type: CoordinatorType = .login
    var delegate: InputInfoCoordinatorDelegate?
    
    override func start() {
        let controller = InputInfoViewController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func dismissView() {
        navigationController?.dismiss(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
}
