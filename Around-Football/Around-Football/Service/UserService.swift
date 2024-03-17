//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import AuthenticationServices
import CryptoKit
import Foundation

import FirebaseAuth
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseCore
import GoogleSignIn
import RxSwift
import RxRelay

final class UserService: NSObject {
    
    // MARK: - Properties
    
    static let shared = UserService()
    var currentNonce: String?
    
    // MARK: - Rx Properties
    
    var currentUser_Rx: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var isLoginObservable: BehaviorSubject<Void> = BehaviorSubject(value: ())
    var isLogoutObservable: PublishSubject<Void> = PublishSubject()
    var checkUserInfoExist: PublishSubject<Bool> = PublishSubject()
    var isLoginProcess: PublishSubject<Bool> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    private override init() {
        super.init()
        configureCurrentUser()
        configureLogOutObserver()
    }
    
    private func configureCurrentUser() {
        isLoginObservable
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<User?> in
                guard let uid = Auth.auth().currentUser?.uid else { return .empty() }
                let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
                print("DEBUG - Set FCMToken: \(fcmToken)")
                return FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken)
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                currentUser_Rx.onNext(user)
                checkUserInfoExist.onNext(true)
                NotiManager.shared.setAppIconBadgeNumber(number: user?.totalAlarmNumber ?? 0)
                isLoginProcess.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureLogOutObserver() {
        isLogoutObservable
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("logout 1")
                guard let uid = try? owner.currentUser_Rx.value()?.id else { return }
                print("logout 2")
                // MARK: - 로그아웃시 nil보냄
                owner.currentUser_Rx.onNext(nil)
                print("logout 3")
                FirebaseAPI.shared.updateFCMToken(uid: uid, fcmToken: "") { error in
                    print("logout 4")
                    print("DEBUG - update logout fcm token")
                    if let error = error {
                        print("logout 5")
                        print("DEBUG - Logout FCM update error", error.localizedDescription as Any)
                        return
                    }
                    print("logout 6")
                }
                
                Messaging.messaging().deleteToken { error in
                    if let error = error {
                        print("DEBUG - deleteToken Error: \(error.localizedDescription)")
                    } else {
                        Messaging.messaging().token { token, _ in
                            if let token = token {
                                print("DEBUG - FCM 토큰", #function, token)
                                UserDefaults.standard.set(token, forKey: "FCMToken")
                            }
                        }
                    }
                }
                
                // Client에 전송된, 전송될 알림 모두 제거
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                center.removeAllDeliveredNotifications()
                
                NotiManager.shared.setAppIconBadgeNumber(number: 0)
            }
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Helpers - Google
    
    func googleSignIn(_ controller: UIViewController) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { [weak self] result, error in
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
            self?.isLoginProcess.onNext(true)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                print("로그인 성공: \(String(describing: result?.user))")
                
                guard let uid = result?.user.uid else { return }
                
                REF_USER.document(uid).getDocument { [weak self] snapshot, error in
                    guard let self else { return }
                    if let snapshot = snapshot, snapshot.exists {
                        isLoginObservable.onNext(())
                    } else {
                        REF_USER.document(uid)
                            .setData(["id": uid]) { [weak self] error in
                                guard let self else { return }
                                if error != nil {
                                    print("setUserDataError: \(String(describing: error?.localizedDescription))")
                                    return
                                }
                                
                                isLoginObservable.onNext(())
                            }
                    }
                }
                
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
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            self?.isLoginProcess.onNext(true)
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            print("loginWithKakaoTalk() success.")
            _ = oauthToken
            self?.getKakaoUserInfo()
        }
    }
    
    func loginKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            self?.isLoginProcess.onNext(true)
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            
            print("loginWithKakaoAccount() success.")
            
            //do something
            _ = oauthToken
            self?.getKakaoUserInfo()
        }
    }
    
    func getKakaoUserInfo() {
        UserApi.shared.me() { [weak self] user, error in
            guard let self else { return }
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            
            print("me() success.")
            
            //do something
            guard let user = user else {
                print("유저없음")
                return }
            
            let email = user.kakaoAccount?.email
            googleSignIn(email: email!, password: email!)
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            guard error == nil else {
                print("\(String(describing: error))")
                return
            }
            self.googleLogOut()
            self.isLogoutObservable.onNext(())
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
            isLogoutObservable.onNext(())
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
                //파베 유저 삭제
                FirebaseAPI.shared.deleteUser(user.uid)
            }
        }
    }
}

// MARK: - LoginViewModel+Kakao

extension UserService {
    //카카오 로그인 파베 유저 생성
    func createGoogleUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let uid = result?.user.uid
            
            REF_USER.document(uid ?? UUID().uuidString)
                .setData(["id": uid ?? UUID().uuidString])
            
            isLoginObservable.onNext(())
        }
    }
    
    //카카오 구글 로그인
    func googleSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            guard error == nil else {
                print(error?.localizedDescription as Any)
                createGoogleUser(email: email, password: password)
                return
            }
            isLoginProcess.onNext(true)
            if result == nil {
                createGoogleUser(email: email, password: password)
                print("유저 만들고 로그인 성공")
            } else {
                print("로그인 성공")
                isLoginObservable.onNext(())
            }
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
        isLoginProcess.onNext(true)
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
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                print("로그인 성공")
                
                guard let uid = authResult?.user.uid else { return }
                
                REF_USER.document(uid).getDocument { [weak self] snapshot, error in
                    guard let self else { return }
                    if let snapshot = snapshot, snapshot.exists {
                        isLoginObservable.onNext(())
                    } else {
                        REF_USER.document(uid)
                            .setData(["id": uid]) { [weak self] error in
                                guard let self else { return }
                                if error != nil {
                                    return
                                }
                                
                                isLoginObservable.onNext(())
                            }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

