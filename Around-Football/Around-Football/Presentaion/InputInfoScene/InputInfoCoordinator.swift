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
        start(hidesBackButton: false)
    }
    
    func start(hidesBackButton: Bool) {
        let controller = InputInfoViewController()
        controller.delegate = self
        controller.navigationItem.hidesBackButton = hidesBackButton
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
