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

class GoogleLoginService {
    
    func googleSignIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
          print("There is no root view controller!")
          return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
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
                print("로그인 성공: \(result?.user)")
                // 로그인 성공 시 MainTabView로 화면 이동
                let mainTabVC = MainTabController()
//                if let navigationController = self?.navigationController {
//                    navigationController.pushViewController(mainTabVC, animated: true)
//                }
            }

        }
    }
}
