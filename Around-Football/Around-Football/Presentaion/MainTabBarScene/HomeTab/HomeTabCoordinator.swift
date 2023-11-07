//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func presentLoginViewController()
    func presentInviteView()
}

final class HomeTabCoordinator: BaseCoordinator, HomeViewControllerDelegate {


    var type: CoordinatorType = .home
    var delegate: HomeTabCoordinatorDelegate?
    
    deinit {
        print("HomeTabCoordinator 해제")
    }
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func presentInviteView() {
        delegate?.presentInviteView()
    }
    
    
}
