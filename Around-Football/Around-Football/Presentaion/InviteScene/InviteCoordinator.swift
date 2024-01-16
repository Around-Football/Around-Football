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
    
    lazy var searchCoordinator = SearchCoordinator(navigationController: navigationController)
    lazy var searchViewModel = SearchViewModel(coordinator: searchCoordinator)
    
    func start(recruit: Recruit? = nil) {
        let inviteViewModel = InviteViewModel(coordinator: self, recruit: recruit)

        let controller = InviteViewController(inviteViewModel: inviteViewModel,
                                              searchViewModel: searchViewModel)
        controller.navigationController?.navigationBar.isHidden = false
        controller.setAFBackButton()
        navigationController?.pushViewController(controller, animated: true)

    }
    
    @objc
    func popInviteViewController() {
        navigationController?.popViewController(animated: true)
        removeThisChildCoordinators()
    }
    
    // SearchViewController Delegate
    func presentSearchViewController() {
//        coordinator.start()
//        childCoordinators.append(coordinator)
        searchCoordinator.start(viewModel: searchViewModel)
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
