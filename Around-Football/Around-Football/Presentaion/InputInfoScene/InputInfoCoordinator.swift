//
//  InputInfoCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

protocol InputInfoCoordinatorDelegate {
    func showMainTabController()
}

final class InputInfoCoordinator: BaseCoordinator, InputInfoViewControllerDelegate {
    var type: CoordinatorType = .login
    var delegate: InputInfoCoordinatorDelegate?
    
    override func start() {
        print("DEBUG: inputInfoViewController 생성")
        let inputInfoViewController = InputInfoViewController()
        inputInfoViewController.delegate = self
        navigationController?.pushViewController(inputInfoViewController, animated: true)
    }
    
    func showMainTabController() {
        delegate?.showMainTabController()
        removeFromChildCoordinators(coordinator: self)
    }
}
