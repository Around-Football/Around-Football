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
import RxSwift

final class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private let viewModel: MainTabViewModel
    private var pages: [UINavigationController]
    private let disposeBag = DisposeBag()
    
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
        bind()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        tabBar.tintColor = .black
        viewControllers = pages
    
        pages[0].tabBarItem = UITabBarItem(title: "홈",
                                           image: UIImage(named: AFIcon.home),
                                           selectedImage: UIImage(named: AFIcon.homeSelect))
        pages[1].tabBarItem = UITabBarItem(title: "지도",
                                           image: UIImage(named: AFIcon.location),
                                           selectedImage: UIImage(named: AFIcon.locationSelect))
        pages[2].tabBarItem = UITabBarItem(title: "채팅",
                                           image: UIImage(named: AFIcon.chat),
                                           selectedImage: UIImage(named: AFIcon.chatSelect))
        pages[3].tabBarItem = UITabBarItem(title: "내 정보",
                                           image: UIImage(named: AFIcon.user),
                                           selectedImage: UIImage(named: AFIcon.userSelect))
        pages[0].tabBarItem.tag = 0
        pages[1].tabBarItem.tag = 1
        pages[2].tabBarItem.tag = 2
        pages[3].tabBarItem.tag = 3
    }
    
    private func bind() {
        bindTabItemBadge()
    }
    
    private func bindTabItemBadge() {
        viewModel.user
            .bind { user in
                guard let user = user else { return }
                if user.totalAlarmNumber > 0 {
                    self.tabBar.items?[2].badgeValue = "\(user.totalAlarmNumber)"
                } else {
                    self.tabBar.items?[2].badgeValue = nil
                }
            }
            .disposed(by: disposeBag)
    }
}
