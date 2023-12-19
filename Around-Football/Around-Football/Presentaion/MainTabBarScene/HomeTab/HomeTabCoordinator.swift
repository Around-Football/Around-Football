//
//  HomeTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol HomeTabCoordinatorDelegate {
    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool)
}

final class HomeTabCoordinator: BaseCoordinator {

    var type: CoordinatorType = .home
    
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
        childCoordinators.append(coordinator)
        navigationController?.navigationBar.isHidden = false
        coordinator.start(recruitItem: recruitItem)
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
    
    func presentLoginViewController() {
        let coordinator = LoginCoordinator()
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }
    
    // TODO: - DetailCoordinator 해제하는 로직 구성
}
