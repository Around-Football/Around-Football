//
//  InfoTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol InfoTabCoordinatorDelegate {
    func presentLoginViewController()
}

final class InfoTabCoordinator: BaseCoordinator, InfoViewControllerDelegate {

    var type: CoordinatorType = .info
    var delegate: InfoTabCoordinatorDelegate?
    
    deinit {
        print("DEBUG: InfoTabCoordinator deinit")
    }
    
    func makeInfoViewController() -> UINavigationController {
        let infoViewModel = InfoViewModel(coordinator: self)
        let infoViewController = InfoViewController(delegate: self, viewModel: infoViewModel)
        navigationController = UINavigationController(rootViewController: infoViewController)
//        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }
        
        return navigationController
    }
    
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func pushEditView() {
        //뷰 재사용, InputInfoCoordinator 사용
        let coordinator = InputInfoCoordinator(navigationController: navigationController)
        navigationController?.navigationBar.prefersLargeTitles = false
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func pushSettingView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
