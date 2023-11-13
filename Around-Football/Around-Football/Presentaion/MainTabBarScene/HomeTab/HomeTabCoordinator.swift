//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func presentLoginViewController()
}

final class HomeTabCoordinator: BaseCoordinator, HomeViewControllerDelegate {


    var type: CoordinatorType = .home
    var delegate: HomeTabCoordinatorDelegate?
    
    deinit {
        print("HomeTabCoordinator deinit")
    }
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func presentInviteView() {
        let controller = UINavigationController(rootViewController: InviteViewController())
        controller.isNavigationBarHidden = false
        navigationController?.present(controller, animated: true)
    }

    
}
