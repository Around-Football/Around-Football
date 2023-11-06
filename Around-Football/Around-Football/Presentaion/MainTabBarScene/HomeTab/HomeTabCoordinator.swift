//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func showLoginViewController()
    func presentToInviteView()
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
    
    func presentToInviteView() {
        print("DEBUG: pushToInviteView")
        delegate?.presentToInviteView()
    }
    
    
}
