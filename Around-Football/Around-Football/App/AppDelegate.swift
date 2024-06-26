//
//  AppDelegate.swift
//  Around-Football
//
//  Created by 강창현 on 2023/09/26.
//

import UIKit
import Firebase

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift
import KakaoMapsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Firebase 구성
        FirebaseApp.configure()
        //kakao 초기화
        SDKInitializer.InitSDK(appKey: APIKey.kakaoKey)
        
        setupFCM(application)
        let _ = UserService.shared
        
        // MARK: - TabBar Background Color Issue
        
        let appearance = UITabBarAppearance()
        let tabBar = UITabBar()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        //네비게이션 탭바 색상 검정색으로
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: AFFont.titleCard as Any]
        
        return true
    }
    
    // MARK: - Google Login SetUp
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func setupFCM(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { isAgree, error in
            if isAgree { print("DEBUG - Notification 알림 허용") }
        }
        application.registerForRemoteNotifications()
    }
}
