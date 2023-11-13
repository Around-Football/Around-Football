//
//  MapTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class MapTabCoordinator: BaseCoordinator, MapViewControllerDelegate {
    var type: CoordinatorType = .map
    
    // MARK: - 맵뷰에서 로그인 안되어있을때 로그인뷰로 이동
    func makeMapViewController() -> UINavigationController {
        // MARK: - 뷰모델 좌표 어디서 넣어
        let mapViewModel = MapViewModel(latitude: 37, longitude: 127)
        mapViewModel.coordinator = self
        let mapViewController = MapViewController(delegate: self, viewModel: mapViewModel)
        navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
}
