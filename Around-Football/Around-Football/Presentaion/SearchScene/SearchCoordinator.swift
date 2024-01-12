//
//  SearchCoordinator.swift
//  Around-Football
//
//  Created by 강창현 on 11/17/23.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {
    var type: CoordinatorType = .map
    
    override func start() {
        let searchViewModel = SearchViewModel(coordinator: self)
        let controller = SearchViewController(searchViewModel: searchViewModel)
        controller.navigationController?.navigationBar.isHidden = false
        controller.setModalAFBackButton()
        let presentViewController = UINavigationController(rootViewController: controller)
        presentViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(presentViewController, animated: true)
        navigationController
    }
    
    @objc
    func dismissSearchViewController() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.removeThisChildCoordinators(coordinator: self)
        })
    }
}
