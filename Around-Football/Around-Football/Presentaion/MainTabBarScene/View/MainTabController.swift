//
//  MainTabController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var viewModel: MainTabViewModel
    var pages: [UINavigationController]
    
    // MARK: - Lifecycles
    
    init(viewModel: MainTabViewModel, pages: [UINavigationController]) {
        self.viewModel = viewModel
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        tabBar.tintColor = .black
        viewControllers = pages
    
        pages[0].tabBarItem = UITabBarItem(title: "홈",
                                           image: UIImage(named: "AFHome"),
                                           selectedImage: UIImage(named: "AFHomeSelect"))
        pages[1].tabBarItem = UITabBarItem(title: "지도",
                                           image: UIImage(named: "AFLocation"),
                                           selectedImage: UIImage(named: "AFLocationSelect"))
        pages[2].tabBarItem = UITabBarItem(title: "채팅",
                                           image: UIImage(named: "AFChat"),
                                           selectedImage: UIImage(named: "AFChatSelect"))
        pages[3].tabBarItem = UITabBarItem(title: "내 정보",
                                           image: UIImage(named: "AFUser"),
                                           selectedImage: UIImage(named: "AFUserSelect"))
        pages[0].tabBarItem.tag = 0
        pages[1].tabBarItem.tag = 1
        pages[2].tabBarItem.tag = 2
        pages[3].tabBarItem.tag = 3
    }
}
