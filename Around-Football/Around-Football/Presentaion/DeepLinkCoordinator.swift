//
//  DeepLinkCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/12/23.
//

import UIKit

protocol DeepLinkCoordinatorDelegate {
    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool)
    func pushToDetailView(recruit: Recruit)
}

final class DeepLinkCoordinator: BaseCoordinator {

    var type: CoordinatorType = .deepLink
    var delegate: DeepLinkCoordinatorDelegate?
    
    func pushToChatView(channelInfo: ChannelInfo, isNewChat: Bool = false) {
        guard let mainTabController = navigationController?.viewControllers.first as? MainTabController else { return }
        //채팅 탭으로 이동
        mainTabController.selectedIndex = 2
        delegate?.pushToChatView(channelInfo: channelInfo, isNewChat: false)
    }
}
