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
    }
}