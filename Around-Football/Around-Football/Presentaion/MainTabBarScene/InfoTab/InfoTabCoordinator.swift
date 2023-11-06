//
//  InfoTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol InfoTabCoordinatorDelegate {
    func showLoginViewController()
}

final class InfoTabCoordinator: BaseCoordinator, InfoViewControllerDelegate {

    var type: CoordinatorType = .info
    var delegate: InfoTabCoordinatorDelegate?
    
    func showLoginViewController() {
        delegate?.showLoginViewController()
    }
    
    func pushToEditView() {
        let controller = EditViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushToSettingView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
