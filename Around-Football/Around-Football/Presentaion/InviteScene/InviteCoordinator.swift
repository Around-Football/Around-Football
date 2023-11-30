//
//  InviteCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/16/23.
//

import UIKit

protocol InviteCoordinatorDelegate {
    func dismissView()
}

final class InviteCoordinator: BaseCoordinator {

    var type: CoordinatorType = .home
    var searchViewModel = SearchViewModel(coordinator: nil)
    
    override func start() {
        let inviteViewModel = InviteViewModel(coordinator: self)
        let controller = InviteViewController(inviteViewModel: inviteViewModel, 
                                              searchViewModel: searchViewModel)
        controller.navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func popInviteViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators()
    }
    
    // SearchBViewController Delegate
    func presentSearchViewController() {
        let coordinator = SearchCoordinator(navigationController: navigationController, 
                                            searchViewModel: searchViewModel)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func removeThisChildCoordinators() {
        removeThisChildCoordinators(coordinator: self)
    }
}
