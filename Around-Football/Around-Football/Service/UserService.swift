//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import CryptoKit

import FirebaseAuth
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import RxSwift
import RxRelay

final class UserService: NSObject {
    
    // MARK: - Properties
    static let shared = UserService()
    
    var user: User?
    
    private var userProfile: String?
    private var email: String?
    var currentNonce: String?
    
    // MARK: - Rx Properties
    var currentUser_Rx: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()
    var isLoginObservable: PublishSubject<Void> = PublishSubject()
    var isLogoutObservable: PublishSubject<Void> = PublishSubject()
    
    
    // MARK: - Lifecycles
    
    private override init() {
        super.init()
        readUser()
        configureCurrentUser()
        configureLogOutObserver()
    }
    
    func readUser() {
        FirebaseAPI.shared.readUser { [weak self] user in
            guard let self else { return }
            self.user = user
            print("DEBUG - LOGIN: \(String(describing: user))")
        }
    }
    
    private func configureCurrentUser() {
        
        isLoginObservable
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<User?> in
                guard let uid = Auth.auth().currentUser?.uid else { return .empty() }
                print("setfcmToken")
                return FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: "fcmToken")
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .subscribe { user in
                self.currentUser_Rx.accept(user)
                NotificationCenter.default.post(name: NSNotification.Name("LoginNotification"),
                                                object: nil,
                                                userInfo: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLogOutObserver() {
        isLogoutObservable
            .withUnretained(self)
            .subscribe { (owner, _) in
                guard let user = owner.user else { return }
                FirebaseAPI.shared.updateFCMToken(uid: user.id, fcmToken: "") { error in
                    print("DEBUG - Logout FCM update error", error?.localizedDescription as Any)
                }
                
                Messaging.messaging().deleteToken { error in
                    if let error = error {
                        print("DEBUG - deleteToken Error: \(error.localizedDescription)")
                    } else {
                        Messaging.messaging().token { token, _ in
                            if let token = token {
                                print("FCM 토큰", #function, token)
                                UserDefaults.standard.set(token, forKey: "FCMToken")
                            }
                        }
                    }
                }

            }
            .disposed(by: disposeBag)
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
                
                if Auth.auth().currentUser?.uid != nil {
                    REF_USER.document(uid ?? UUID().uuidString)
                        .setData(["id" : uid ?? UUID().uuidString])
                }
                
                self.isLoginObservable.onNext(())
                
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
            Auth.auth().signIn(withEmail: self.email!, password: self.email!) { _, error in
                guard let error = error else { return }
                self.isLoginObservable.onNext(())
            }
            

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
        //        authorizationController.delegate = self
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
            isLogoutObservable.onNext(())
            self.user = nil
            self.currentUser_Rx.accept(nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
            self.isLoginObservable.onNext(())

        }
    }
    
    func googleLogOut() {
        try? Auth.auth().signOut()
        isLogoutObservable.onNext(())
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
                
                let uid = authResult?.user.uid
                
                REF_USER.document(uid ?? UUID().uuidString)
                    .setData(["id" : uid ?? UUID().uuidString])
                
                self.isLoginObservable.onNext(())

                // TODO: - Coordinator Refactoring
                NotificationCenter.default.post(name: NSNotification.Name("TestNotification"),
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

