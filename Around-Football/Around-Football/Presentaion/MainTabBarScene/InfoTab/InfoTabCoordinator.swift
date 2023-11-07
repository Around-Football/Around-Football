//
//  InfoTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol InfoTabCoordinatorDelegate {
    func presentLoginViewController()
}

final class InfoTabCoordinator: BaseCoordinator, InfoViewControllerDelegate {

    var type: CoordinatorType = .info
    var delegate: InfoTabCoordinatorDelegate?
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func pushEditView() {
        let coordinator = InputInfoCoordinator(navigationController: navigationController)
        coordinator.start(hidesBackButton: false)
        childCoordinators.append(coordinator)
    }
    
    func pushSettingView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
