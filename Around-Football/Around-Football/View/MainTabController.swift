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
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLogin()
    }
    
    // MARK: - Helpers
    
    private func isLogin() {
//        if Auth.auth().currentUser?.uid == nil {
            let controller = SocialLoginViewController()
            present(controller, animated: true)
            print("로그인화면으로")
//        } else {
            print("자동로그인")
            UserApi.shared.me { user, error in
                print("user: \(user?.kakaoAccount)")
            }
//        }
    }
    
    private func configureUI() {
        tabBar.tintColor = .black
    }
    
    private func configureViewController() {
        let homeViewController = HomeViewController()
        let homeNavigation: UINavigationController = makeNavigationController(
            rootViewController: homeViewController,
            title: "Home",
            tabbarImage: "house",
            tag: 0
        )
        
        let mapViewController = MapViewController()
        let mapNavigation: UINavigationController = makeNavigationController(
            rootViewController: mapViewController,
            title: "Map",
            tabbarImage: "map",
            tag: 1
        )
        
        
        let infoViewController = InfoViewController()
        let infoNavigation: UINavigationController = makeNavigationController(
            rootViewController: infoViewController,
            title: "Info",
            tabbarImage: "info.square",
            tag: 2
        )
        
        viewControllers = [homeNavigation, mapNavigation, infoNavigation]
    }
    
    private func makeNavigationController(
        rootViewController rootVC: UIViewController,
        title: String,
        tabbarImage: String,
        tag: Int
    ) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootVC)
        
        // TODO: - SET TabBar Image (add image constant to function input area)
        
        navigation.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: tabbarImage),
            tag: tag
        )
        
        return navigation
    }
}
