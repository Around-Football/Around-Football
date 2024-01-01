//
//  MapTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class MapTabCoordinator: BaseCoordinator {
    var type: CoordinatorType = .map
    
    // MARK: - 맵뷰에서 로그인 안되어있을때 로그인뷰로 이동
    func makeMapViewController() -> UINavigationController {
        // MARK: - 뷰모델 좌표 어디서 넣어? 일단 임시로 좌표 넣음
        let mapViewModel = MapViewModel(latitude: 37, longitude: 127)
        let searchViewModel = SearchViewModel(coordinator: nil)
        mapViewModel.coordinator = self
        let mapViewController = MapViewController(viewModel: mapViewModel, searchViewModel: searchViewModel)
        navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController?.navigationBar.isHidden = false
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
}
