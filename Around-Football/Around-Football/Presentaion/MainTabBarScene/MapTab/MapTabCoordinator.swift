//
//  MapTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class MapTabCoordinator: BaseCoordinator {
    var type: CoordinatorType = .map
    
    lazy var searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
    lazy var searchViewModel = SearchViewModel(coordinator: searchCoordinator)
    
    // MARK: - 맵뷰에서 로그인 안되어있을때 로그인뷰로 이동
    func makeMapViewController() -> UINavigationController {
        // MARK: - 뷰모델 좌표 어디서 넣어? 일단 임시로 좌표 넣음
        let mapViewModel = MapViewModel(coordinator: self, latitude: 37, longitude: 127)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        self.navigationController = UINavigationController(rootViewController: mapViewController)
        self.navigationController?.navigationBar.isHidden = false
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        mapViewController.searchViewModel = self.searchViewModel
        searchViewModel.coordinator?.navigationController = self.navigationController
        
        return navigationController
    }
    
    func presentSearchViewController() {
        self.searchCoordinator.start(viewModel: self.searchViewModel)
    }
    
    func presentDetailViewController(recruits: [Recruit]) {
        let fieldViewModel = FieldDetailViewModel(coordinator: self, recruits: recruits)
        let modalViewController = FieldDetailViewController(viewModel: fieldViewModel)
        let navigation = UINavigationController(rootViewController: modalViewController)
        navigationController?.present(navigation, animated: true)
    }
    
    // TODO: - FieldDetailCoordinator 필요 여부
    func pushToDetailView(recruitItem: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        navigationController?.navigationBar.isHidden = false
        coordinator.start(recruitItem: recruitItem)
    }
    
    func clickSendMessageButton(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        if navigationController?.viewControllers.first(where: { $0 is ChatViewController }) != nil {
            navigationController?.popViewController(animated: true)
            removeThisChildCoordinators(coordinator: self)
        } else {
            let coordinator = ChatCoordinator(navigationController: navigationController)
            coordinator.start(channelInfo: channelInfo, isNewChat: isNewChat)
            childCoordinators.append(coordinator)
        }
    }
}
