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

/*
 func authenticateUserAndConfigureUI() {
     if Auth.auth().currentUser == nil {
         DispatchQueue.main.async {
             let logInNavigation = UINavigationController(rootViewController: LoginController())
             logInNavigation.modalPresentationStyle = .fullScreen
             self.present(logInNavigation, animated: true)
         }
     } else {
         configureViewControllers()
         configureUI()
         fetchUser()
     }
 }

 // MARK: - Lifecycle
 override func viewDidLoad() {
     super.viewDidLoad()
     
     view.backgroundColor = .twitterBlue
     authenticateUserAndConfigureUI()
 }
 */


final class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var loginViewModel = LoginViewModel()
    
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
        if Auth.auth().currentUser == nil {
            let controller = SocialLoginViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
            print("로그인화면으로")
        } else {
            print("자동로그인")
        }
    }
    
    private func configureUI() {
        tabBar.tintColor = .black
    }
    
    private func configureViewController() {
        
        let homeTableViewController = HomeViewController()
        let homeNavigation: UINavigationController = makeNavigationController(
            rootViewController: homeTableViewController,
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
