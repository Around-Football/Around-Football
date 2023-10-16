//
//  KakaoLoginService.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/16/23.
//

import Foundation

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class KakaoLoginService {
    var userProfile: String?
    var email: String?
    
    func onKakaoLoginByAppTouched() {
        var isInstalledKakaoApp = UserApi.isKakaoTalkLoginAvailable()
        // 카카오톡 설치 여부 확인
        if isInstalledKakaoApp {
            loginKakaoApp()
        } else {
            loginKakaoAccount()
        }
    }
    
    func loginKakaoApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                _ = oauthToken
            }
            
//            createGoogleUser(email: <#T##String#>, password: <#T##String#>)
        }
    }
    
    func loginKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount {oauthToken, error in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
    func getKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                _ = user
                
                self.userProfile = user?.kakaoAccount?.profile?.nickname
                self.email = user?.kakaoAccount?.email
                print("userProfile: \(self.userProfile), email: \(self.email)")
            }
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
}

extension KakaoLoginService {
    //파베 유저 생성
    func createGoogleUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            self.googleSignIn(email: email, password: password) //로그인
            
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
            print(result?.user)
        }
    }
}
