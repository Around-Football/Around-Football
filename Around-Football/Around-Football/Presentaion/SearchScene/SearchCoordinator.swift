//
//  SearchCoordinator.swift
//  Around-Football
//
//  Created by 강창현 on 11/17/23.
//

import UIKit

//protocol SearchCoordinatorDelegate {
//    func presentSearchViewController()
//}

final class SearchCoordinator: BaseCoordinator {
    var type: CoordinatorType = .map
    var searchViewModel: SearchViewModel
    
    init(navigationController: UINavigationController?, searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        searchViewModel.coordinator = self
        let controller = SearchViewController(searchViewModel: searchViewModel)
        navigationController?.present(controller, animated: true)
    }
    
    func dismissSearchViewController() {
        navigationController?.dismiss(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
}
