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

        configureViewController()
    }

    func configureUI() {
        // TabBar UI
    }
    
    func configureViewController() {
        let homeViewController = HomeViewController()
        let homeNavigation: UINavigationController = makeNavigationController(rootViewController: homeViewController, title: "Home")
        
        let mapViewController = MapViewController()
        let mapNavigation: UINavigationController = makeNavigationController(rootViewController: mapViewController, title: "Map")
        
        let infoViewController = InfoViewController()
        let infoNavigation: UINavigationController = makeNavigationController(rootViewController: infoViewController, title: "Info")
        
        viewControllers = [homeNavigation, mapNavigation, infoNavigation]
    }
    
    func makeNavigationController(rootViewController: UIViewController, title: String) -> UINavigationController {
        let navigation: UINavigationController = UINavigationController(rootViewController: rootViewController)
        // TODO: - SET TabBar Image (add image constant to function input area)
        // navigation.tabBarItem.image = image
        navigation.tabBarItem.title = title
        
        return navigation
    }
}
