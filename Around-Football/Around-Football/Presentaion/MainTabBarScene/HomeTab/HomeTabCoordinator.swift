//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func presentLoginViewController()
    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool)
}

final class HomeTabCoordinator: BaseCoordinator, MainTabBarCoordinatorDelegate {

    var type: CoordinatorType = .home
    var delegate: MainTabBarCoordinatorDelegate?
// final class HomeTabCoordinator: BaseCoordinator, DetailCoordinatorDelegate {
    
//     var type: CoordinatorType = .home
//     var delegate: HomeTabCoordinatorDelegate?
//     lazy var detailCoordinator = DetailCoordinator(navigationController: navigationController)
    
    deinit {
        print("HomeTabCoordinator deinit")
    }
    
    func makeHomeViewController() -> UINavigationController {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeViewController)
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    func pushToDetailView(recruitItem: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        navigationController?.navigationBar.isHidden = false
        coordinator.delegate = self
        coordinator.start(recruitItem: recruitItem)

        // detailCoordinator.recruitItem = recruitItem
        // detailCoordinator.delegate = self
//        navigationController?.navigationBar.isHidden = false
        // detailCoordinator.start(recruitItem: recruitItem)
    }

    func pushMapView() {
        
        // MARK: - MapView이동시 coordinator 사용
        
        let controller = MapViewController(viewModel: MapViewModel(latitude: 37, longitude: 126))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushInviteView() {
        let coordinator = InviteCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.navigationController?.navigationBar.isHidden = false
    }
    
    //DetailCoordinatorDelegate
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool) {
        delegate?.pushToChatView(channelInfo: channelInfo, isNewChat: isNewChat)
    }
}
