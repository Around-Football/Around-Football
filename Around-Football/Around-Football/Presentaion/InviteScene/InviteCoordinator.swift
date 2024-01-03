//
//  InviteCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/16/23.
//

import UIKit

protocol InviteCoordinatorDelegate {
    func dismissView()
}

final class InviteCoordinator: BaseCoordinator {

    var type: CoordinatorType = .home
    var searchViewModel = SearchViewModel(coordinator: nil)
    
    override func start() {
        let inviteViewModel = InviteViewModel(coordinator: self)
        let controller = InviteViewController(inviteViewModel: inviteViewModel, 
                                              searchViewModel: searchViewModel)
        controller.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        let AFBackButton = UIBarButtonItem(image: UIImage(named: AFIcon.backButton), style: .plain, target: self, action: #selector(popInviteViewController))
        AFBackButton.tintColor = AFColor.grayScale200
        controller.navigationItem.setLeftBarButton(AFBackButton, animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc
    func popInviteViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators()
    }
    
    // SearchViewController Delegate
    func presentSearchViewController() {
        let coordinator = SearchCoordinator(navigationController: navigationController, 
                                            searchViewModel: searchViewModel)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func presentPHPickerView(picker: UIViewController) {
        navigationController?.present(picker, animated: true)
    }
    
    func removeThisChildCoordinators() {
        removeThisChildCoordinators(coordinator: self)
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
