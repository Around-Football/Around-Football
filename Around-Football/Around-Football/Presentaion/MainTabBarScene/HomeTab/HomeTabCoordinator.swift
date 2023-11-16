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

final class HomeTabCoordinator: BaseCoordinator {

    var type: CoordinatorType = .home
    var delegate: HomeTabCoordinatorDelegate?
    
    deinit {
        print("HomeTabCoordinator deinit")
    }
    
    func makeHomeViewController() -> UINavigationController {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeTableViewController = HomeTableViewController(viewModel: homeViewModel)
        let homeViewController = HomeViewController(homeTableViewController: homeTableViewController, viewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeViewController)
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func pushToDetailView() {
        let detailVc = DetailViewController()
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(detailVc, animated: true)
    }
    

    func pushMapView() {
        // MARK: - MapView이동시 coordinator 사용
        let controller = MapViewController(viewModel: MapViewModel(latitude: 37, longitude: 126))
        navigationController?.pushViewController(controller, animated: true)
    }

    func pushApplicationStatusView() {
        let ApplicationStatusVc = ApplicationStatusViewController()
        navigationController?.pushViewController(ApplicationStatusVc, animated: true)

    }
    
    func pushInviteView() {
        let coordinator = InviteCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.navigationController?.navigationBar.isHidden = false
    }
}
