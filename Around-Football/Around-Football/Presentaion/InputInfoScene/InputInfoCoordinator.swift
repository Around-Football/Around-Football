//
//  InputInfoCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

final class InputInfoCoordinator: BaseCoordinator, InputInfoViewControllerDelegate {
    var type: CoordinatorType = .login
    
    override func start() {
        print("DEBUG: inputInfoViewController 생성")
        let controller = InputInfoViewController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func dismissView() {
        navigationController?.dismiss(animated: true)
        removeFromChildCoordinators(coordinator: self)
    }
}
