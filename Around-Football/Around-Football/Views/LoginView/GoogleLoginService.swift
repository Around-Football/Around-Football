//
//  GoogleLoginService.swift
//  Around-Football
//
//  Created by 강창현 on 10/18/23.
//

import Foundation

import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class GoogleLoginService: UIViewController {
    
    func googleSignIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                // ...
                print("signIn ERROR: \(error?.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                print("idToken 에러")
                return
            }
            print("구글 로그인 Flow 진행")
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                
                // 로그인 성공 시 MainTabView로 화면 이동
                let mainTabVC = MainTabController()
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(mainTabVC, animated: true)
                }   
            }
            
        }
    }
    //    func createGoogleUser(email: String, password: String) {
    //        Auth.auth().createUser(withEmail: email, password: password) { result, error in
    //            guard error == nil else {
    //                print(error?.localizedDescription as Any)
    //                return
    //            }
    //
    //            self.googleSignIn(email: email, password: password) //로그인
    //        }
    //    }
    //
    //    //구글 로그인
    //    func googleSignIn(email: String, password: String) {
    //        Auth.auth().signIn(withEmail: email, password: password) { result, error in
    //            guard error == nil else {
    //                print(error?.localizedDescription as Any)
    //                return
    //            }
    //
    //            print("로그인 성공")
    //            print(result?.user)
    //        }
    //    }
}
