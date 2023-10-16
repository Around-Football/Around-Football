//
//  AppDelegate.swift
//  Around-Football
//
//  Created by 강창현 on 2023/09/26.
//

import UIKit
import Firebase

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - Firebase SetUp
        FirebaseApp.configure()

        // MARK: - Apple Login SetUp
//        var window: UIWindow?
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//           appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//               switch credentialState {
//               case .authorized:
//                   break // The Apple ID credential is valid.
//               case .revoked, .notFound:
//                   // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                   DispatchQueue.main.async {
//                       self.window?.rootViewController?.showLoginViewController()
//                   }
//               default:
//                   break
//               }
//           }
    
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


}

