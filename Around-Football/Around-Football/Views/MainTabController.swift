//
//  MainTabController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewController()
    }
    
    func configureUI() {
        tabBar.tintColor = .black
    }
    
    func configureViewController() {
//        let homeViewController = HomeViewController()
        let homeTableViewController = HomeTableViewController()
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
    
    func makeNavigationController(rootViewController rootVC: UIViewController,
                                  title: String,
                                  tabbarImage: String,
                                  tag: Int) -> UINavigationController {
        let navigation: UINavigationController = UINavigationController(rootViewController: rootVC)
        // TODO: - SET TabBar Image (add image constant to function input area)
        navigation.tabBarItem = UITabBarItem(title: title,
                                             image: UIImage(systemName: tabbarImage),
                                             tag: tag)
        
        return navigation
    }
}
