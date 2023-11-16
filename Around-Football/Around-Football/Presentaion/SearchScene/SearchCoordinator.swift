//
//  SearchCoordinator.swift
//  Around-Football
//
//  Created by 강창현 on 11/17/23.
//

import Foundation

//protocol SearchCoordinatorDelegate {
//    func presentSearchViewController()
//}

final class SearchCoordinator: BaseCoordinator {
    var type: CoordinatorType = .map
    
    override func start() {
        let viewModel = SearchViewModel(coordinator: self)
        let controller = SearchViewController(viewModel: viewModel)
        navigationController?.present(controller, animated: true)
    }
    
    func dismissSearchViewController() {
//        navigationController?.dismiss(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
}
