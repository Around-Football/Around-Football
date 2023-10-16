//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation

import Firebase
import GoogleSignIn

class LoginViewModel {
    
    // MARK: - Properties
    
    enum State {
      case signedIn(GIDGoogleUser)
      case signedOut
    }
    
    var state: State

    init() {
      if let user = GIDSignIn.sharedInstance.currentUser {
        self.state = .signedIn(user)
      } else {
        self.state = .signedOut
      }
    }
    // MARK: - Helpers
    // Google Login SetUp
    func login() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = windowScene.windows
            guard let rootViewController = windows.first?.rootViewController else {
              print("There is no root view controller!")
              return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
              guard let signInResult = signInResult else {
                print("Error! \(String(describing: error))")
                return
              }
        }

//        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
//          guard let signInResult = signInResult else {
//            print("Error! \(String(describing: error))")
//            return
//          }
//          self.authViewModel.state = .signedIn(signInResult.user)
        }
    }
//    func login(completion: @escaping (Bool, Error?) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(withPresenting: TestLoginViewController()) {  result, error in
//            guard error == nil else {
//                // ...
//                return
//            }
//            
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//            else {
//                // ...
//                return
//            }
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: user.accessToken.tokenString)
//            
//            Auth.auth().signIn(with: credential) { result, error in
//                if let error = error {
//                    completion(false, error)
//                    print("실패")
//                } else {
//                    completion(true, nil)
//                    print("성공")
//                }
//            }
//        }
//    }
}
