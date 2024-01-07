//
//  InfoTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

final class InfoTabCoordinator: BaseCoordinator {

    var type: CoordinatorType = .info
    
    deinit {
        print("DEBUG: InfoTabCoordinator deinit")
    }
    
    func makeInfoViewController() -> UINavigationController {
        let infoViewModel = InfoViewModel(coordinator: self)
        let infoViewController = InfoViewController(viewModel: infoViewModel)
        navigationController = UINavigationController(rootViewController: infoViewController)
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }
        
        return navigationController
    }
    
    func presentLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start() //여기서 모달뷰로 만듬
        childCoordinators.append(coordinator)
    }

    func pushDetailCell(recruitItem: Recruit) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start(recruitItem: recruitItem)
        
//        let viewModel = DetailViewModel(coordinator: coordinator, recruitItem: recruitItem)
//        let vc = DetailViewController(viewModel: viewModel)
//        vc.setAFBackButton()
//        navigationController?.pushViewController(vc, animated: true)
    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushSettingView() {
        let viewModel = SettingViewModel(coordinator: self)
        let vc = SettingViewController(viewModel: viewModel)
        vc.setAFBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 관심 글, 작성 글 ,신청 글 이동
    
    func pushEditView() {
        //뷰 재사용, InputInfoCoordinator 사용
        let coordinator = InputInfoCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func pushBookmarkPostViewController() {
        let viewModel = InfoPostViewModel(coordinator: self)
        let vc = BookmarkPostViewController(viewModel: viewModel)
        vc.setAFBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushWrittenPostViewController() {
        let viewModel = InfoPostViewModel(coordinator: self)
        let vc = WrittenPostViewController(viewModel: viewModel)
        vc.setAFBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushApplicationPostViewController() {
        let viewModel = InfoPostViewModel(coordinator: self)
        let vc = ApplicationPostViewController(viewModel: viewModel)
        vc.setAFBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 약관 웹 뷰
    func pushWebViewController(url: String) {
        let viewModel = SettingViewModel(coordinator: self)
        let vc = WebViewController(viewModel: viewModel, url: url)
        vc.setAFBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
}


