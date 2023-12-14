//
//  ChatTabCoordinator.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

protocol ChatTabCoordinatorDelegate {
    func presentLoginViewController()
}

final class ChatTabCoordinator: BaseCoordinator, ChatCoordinatorProtocol {
    
    var type: CoordinatorType = .chat
    var delegate: ChatTabCoordinatorDelegate?
    
    deinit {
        print("DEBUG: ChatTabCoordinator deinit")
    }
    
    func makeChannelViewController() -> UINavigationController {
        let channelViewModel = ChannelViewModel(coordinator: self)
        let channelViewController = ChannelViewController(viewModel: channelViewModel)
        navigationController = UINavigationController(rootViewController: channelViewController)
        navigationController?.navigationBar.isHidden = false
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    //채팅 상단 탭 누르면 디테일뷰 진입
    func pushToDetailView(recruitItem: Recruit) {
        let viewModel = DetailViewModel(coordinator: nil, recruitItem: recruitItem)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
      
    func presentLoginViewController() {
        delegate?.presentLoginViewController()
    }
    
    func popCurrnetPage() {
        navigationController?.popViewController(animated: true)
    }
}
