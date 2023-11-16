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
    
    override func start() {
        let inviteViewModel = InviteViewModel(coordinator: self)
        let searchViewModel = SearchViewModel()
        let controller = InviteViewController(viewModel: inviteViewModel,
                                              searchViewModel: searchViewModel)
        controller.navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func popInviteViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators()
    }
    
    func removeThisChildCoordinators() {
        removeThisChildCoordinators(coordinator: self)
    }
}
