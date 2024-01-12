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
    
    func deepLinkApplicantView(recruit: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        navigationController?.navigationBar.isHidden = false
        coordinator.deepLinkApplicationViewController(recruit: recruit)
    }

//    func pushMapView() {
//        let coordinator = MapTabCoordinator(navigationController: navigationController)
//        let controller = MapViewController(viewModel: MapViewModel(coordinator: coordinator, latitude: 37, longitude: 126), searchViewModel: sear)
//        navigationController?.pushViewController(controller, animated: true)
//    }
    
    func pushInviteView() {
        let coordinator = InviteCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func presentLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }
    
    // TODO: - DetailCoordinator 해제하는 로직 구성
}
