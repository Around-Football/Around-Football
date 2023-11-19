//
//  DetailCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/17/23.
//

import Foundation

final class DetailCoordinator: BaseCoordinator {
    
    var type: CoordinatorType = .detailScene
    
    override func start() {
        let viewModel = DetailViewModel(coordinator: self)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
        childCoordinators.append(self)
    }
    
    func popDetailViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators(coordinator: self)
    }
    
    func pushApplicationStatusViewController() {
        let controller = ApplicationStatusViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
