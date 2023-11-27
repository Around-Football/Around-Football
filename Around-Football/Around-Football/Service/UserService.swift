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

final class UserService: NSObject {
    
    // MARK: - Properties
    static let shared = UserService()
    
    var user: User?
    
    private var userProfile: String?
    private var email: String?
    var currentNonce: String?
    
    // MARK: - Lifecycles
    
    private override init() {
        super.init()
        readUser()
    }
    
    func readUser() {
        FirebaseAPI.shared.readUser { [weak self] user in
            guard let self else { return }
            self.user = user
        }
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
                
                let uid = result?.user.uid
                
                if Auth.auth().currentUser?.uid == nil {
                    REF_USER.document(uid ?? UUID().uuidString)
                        .setData(["id" : uid ?? UUID().uuidString])
                }
                
                // TODO: - Coordinator Refactoring
                NotificationCenter.default.post(name: NSNotification.Name("LoginNotification"),
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
            NotificationCenter.default.post(name: NSNotification.Name("LoginNotification"),
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
        print("애플로그인 진행")
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
            self.user = nil
            print("userLogout")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func deleteUser() {
        guard let user = Auth.auth().currentUser else {
            // 유저가 현재 로그인되어 있지 않은 경우
            print("No user is currently signed in.")
            return
        }
        
        user.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("User deleted successfully.")
            }
        }
    }
}

// MARK: - LoginViewModel+Kakao

extension UserService {
    //파베 유저 생성
    func createGoogleUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let uid = result?.user.uid
            
            REF_USER.document(uid ?? UUID().uuidString)
                .setData(["id" : uid ?? UUID().uuidString])
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

extension UserService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                print("로그인 성공")
                let uid = authResult?.user.uid
                
                REF_USER.document(uid ?? UUID().uuidString)
                    .setData(["id" : uid ?? UUID().uuidString])
                
                // TODO: - Coordinator Refactoring
                NotificationCenter.default.post(name: NSNotification.Name("LoginNotification"),
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

