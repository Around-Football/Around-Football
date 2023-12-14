//
//  DeepLinkCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/12/23.
//

import UIKit

protocol DeepLinkCoordinatorDelegate {
    func pushChatView(channelInfo: ChannelInfo, isNewChat: Bool)
}

final class DeepLinkCoordinator: BaseCoordinator {

    var type: CoordinatorType = .deepLink
    var deepLinkDelegate: DeepLinkCoordinatorDelegate?
    
    func pushToChatViewController(channelInfo: ChannelInfo) {
        guard let mainTabController = navigationController?.viewControllers.first as? MainTabController else { return }
        //채팅 탭으로 이동
        mainTabController.selectedIndex = 2
        deepLinkDelegate?.pushChatView(channelInfo: channelInfo, isNewChat: false)
    }
}
