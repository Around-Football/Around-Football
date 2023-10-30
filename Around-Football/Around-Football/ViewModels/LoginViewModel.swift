//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import CryptoKit

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

class LoginViewModel: NSObject {
    
    // MARK: - Properties
    
    private var userProfile: String?
    private var email: String?
    var currentNonce: String?
    
    override init() {
        super.init()
    }
    
    // MARK: - Helpers - Google
    
    func googleSignIn(_ controller: UIViewController) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { result, error in
            guard error == nil else {
                // ...
                print("signIn ERROR: \(String(describing: error?.localizedDescription))")
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
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                print("로그인 성공: \(String(describing: result?.user))")
 
                // TODO: - Coordinator Refactoring
                NotificationCenter.default.post(name: NSNotification.Name("TestNotification"),
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
    
    // MARK: - Helpers - Kakao
    
    func kakaoSignIn() {
        let isInstalledKakaoApp = UserApi.isKakaoTalkLoginAvailable()
        // 카카오톡 설치 여부 확인
        if isInstalledKakaoApp {
            loginKakaoApp()
        } else {
            loginKakaoAccount()
        }
    }
    
    func loginKakaoApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            
            print("loginWithKakaoTalk() success.")
            
            //do something
            _ = oauthToken
            
            self.getKakaoUserInfo()
            
        }
    }
    
    func loginKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount {oauthToken, error in
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            
            print("loginWithKakaoAccount() success.")
            
            //do something
            _ = oauthToken
            
            self.getKakaoUserInfo()
        }
    }
    
    func getKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            
            print("me() success.")
            
            //do something
            _ = user
            
            self.userProfile = user?.kakaoAccount?.profile?.nickname
            self.email = user?.kakaoAccount?.email
            print("userProfile: \(String(describing: self.userProfile)), email: \(String(describing: self.email))")
            self.createGoogleUser(email: self.email!, password: "\(self.email!)")
            
            // TODO: - Coordinator Refactoring
            NotificationCenter.default.post(name: NSNotification.Name("TestNotification"),
                                            object: nil,
                                            userInfo: nil)
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            self.googleLogOut()
            print("logout() success.")
            
        }
    }
    
    // MARK: - Helpers - Apple
    
    func appleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

// MARK: - LoginViewModel+Kakao

extension LoginViewModel {
    //파베 유저 생성
    func createGoogleUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
//            self.googleSignIn(email: email, password: password) //로그인
        }
    }
    
    //구글 로그인
    func googleSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            print("로그인 성공")
        }
    }
    
    func googleLogOut() {
        try? Auth.auth().signOut()
        print("로그아웃 성공")
    }
}
