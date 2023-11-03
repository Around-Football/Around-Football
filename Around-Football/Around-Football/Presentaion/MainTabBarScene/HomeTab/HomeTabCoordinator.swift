//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func showLoginViewController()
    func pushToInviteView()
}

final class HomeTabCoordinator: BaseCoordinator, HomeViewControllerDelegate {

    var type: CoordinatorType = .home
    var delegate: HomeTabCoordinatorDelegate?
    
    deinit {
        print("HomeTabCoordinator 해제")
    }
    
    func showLoginViewController() {
        //
    }
    
    func pushToInviteView() {
        print("DEBUG: pushToInviteView")
        delegate?.pushToInviteView()
//        let controller = Home
    }
    
    
}
