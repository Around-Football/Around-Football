//
//  MainTabBarCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol MainTabBarCoordinatorDelegate {
    func presentLoginViewController()
}

final class MainTabBarCoordinator: BaseCoordinator {

    var type: CoordinatorType = .mainTab
    var delegate: MainTabBarCoordinatorDelegate?
    var deepLinkCoordinator: DeepLinkCoordinator?
    
    override func start() {
        showMainTabController()
    }
    
    deinit {
        print("DEBUG: MainTabBarCoordinator deinit")
    }
    
    private func showMainTabController() {
        navigationController?.isNavigationBarHidden = true
        // MARK: - navigationController 내부에서 새로 만들어줌
        let homeTabCoordinator = HomeTabCoordinator(navigationController: nil)
        let mapTabCoordinator = MapTabCoordinator(navigationController: nil)
        let chatTabCoordinator = ChatTabCoordinator(navigationController: nil)
        let infoTabCoordinator = InfoTabCoordinator(navigationController: self.navigationController)
        
        childCoordinators.append(homeTabCoordinator)
        childCoordinators.append(mapTabCoordinator)
        childCoordinators.append(chatTabCoordinator)
        childCoordinators.append(infoTabCoordinator)
        
        homeTabCoordinator.delegate = self
        infoTabCoordinator.delegate = self
        chatTabCoordinator.delegate = self
        
        let homeViewController = homeTabCoordinator.makeHomeViewController()
        let mapViewController = mapTabCoordinator.makeMapViewController()
        let channelViewController = chatTabCoordinator.makeChannelViewController()
        let infoViewController = infoTabCoordinator.makeInfoViewController()

        makeMainTabBarController(homeVC: homeViewController,
                                 mapVC: mapViewController,
                                 chatVC: channelViewController,
                                 infoVC: infoViewController)
        
        //딥링크와 앱 코디네이터, 네비게이션 컨트롤러 연결
        let deepLinkCoordinator = DeepLinkCoordinator(
            navigationController: navigationController)
        deepLinkCoordinator.deepLinkDelegate = self
        childCoordinators.append(deepLinkCoordinator)
        self.deepLinkCoordinator = deepLinkCoordinator
    }
    

    private func makeMainTabBarController(
        homeVC: UINavigationController,
        mapVC: UINavigationController,
        chatVC: UINavigationController,
        infoVC: UINavigationController
    ) {
        let viewModel = MainTabViewModel()
        let mainTabBarController = MainTabController(viewModel: viewModel,
                                                     pages: [homeVC, mapVC, chatVC, infoVC])
        navigationController?.viewControllers = [mainTabBarController]
    }
    
    // HomeTabCoordinatorDelegate
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    //DeepLinkCoordinatorDelegate
    //딥링크 관련 함수 작성
    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool) {
        print("MainTabBarCoordinator함수")
        let viewModel = ChatViewModel(coordinator: nil, channelInfo: channelInfo, isNewChat: isNewChat)
        let controller = ChatViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.isNavigationBarHidden = false
    }
}

extension MainTabBarCoordinator: HomeTabCoordinatorDelegate, InfoTabCoordinatorDelegate, ChatTabCoordinatorDelegate, DeepLinkCoordinatorDelegate  {
}
