//
//  DeepLinkCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/12/23.
//

import UIKit

//ChatCoordinator 추상화
//protocol ChatCoordinatorProtocol: BaseCoordinator {
//    var navigationController: UINavigationController? { get }
//    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool)
//    func presentPHPickerView(picker: UIViewController)
//    func presentDeleteAlertController(alert: UIAlertController)
//    func pushToDetailView(recruitItem: Recruit)
//}

//chatProtocol 중복 메서드 기본구현
//extension ChatCoordinatorProtocol {
////    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool = false) {
////        let viewModel = ChatViewModel(coordinator: self, channelInfo: channelInfo, isNewChat: isNewChat)
////        let controller = ChatViewController(viewModel: viewModel)
////        controller.hidesBottomBarWhenPushed = true
////        navigationController?.pushViewController(controller, animated: true)
////        navigationController?.isNavigationBarHidden = false
////    }
//    
//    func presentPHPickerView(picker: UIViewController) {
//        navigationController?.present(picker, animated: true)
//    }
//    
//    func presentDeleteAlertController(alert: UIAlertController) {
//        navigationController?.present(alert, animated: true)
//    }
//    
//    func pushToDetailView(recruitItem: Recruit) {
//        if navigationController?.viewControllers.first(where: { $0 is DetailViewController }) != nil {
//            navigationController?.popViewController(animated: true)
//            removeThisChildCoordinators(coordinator: self)
//        } else {
//            let coordinator = DetailCoordinator(navigationController: navigationController)
//            navigationController?.navigationBar.isHidden = false
//            coordinator.start(recruitItem: recruitItem)
//        }
//    }
//}

//final class DeepLinkCoordinator: BaseCoordinator {
//    
//    var type: CoordinatorType = .deepLink
//    var chatTabCoordinator: ChatTabCoordinator?
//
//// protocol DeepLinkCoordinatorDelegate {
////     func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool)
////     func pushToDetailView(recruit: Recruit)
//// }
//
//// final class DeepLinkCoordinator: BaseCoordinator {
//
////     var type: CoordinatorType = .deepLink
////     var delegate: DeepLinkCoordinatorDelegate?
//    
//    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool = false) {
//        guard let mainTabController = navigationController?.viewControllers.first as? MainTabController else { return }
//        //채팅 탭으로 이동
//        mainTabController.selectedIndex = 2
//    }
//}
