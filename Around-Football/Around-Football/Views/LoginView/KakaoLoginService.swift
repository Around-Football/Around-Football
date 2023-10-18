//
//  KakaoLoginService.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/16/23.
//

import UIKit

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class KakaoLoginService {
    private var userProfile: String?
    private var email: String?
    
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
            guard error == nil else {
                print(error)
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
                print(error)
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
                print(error)
                return
            }
            
            print("me() success.")
            
            //do something
            _ = user
            
            self.userProfile = user?.kakaoAccount?.profile?.nickname
            self.email = user?.kakaoAccount?.email
            print("userProfile: \(self.userProfile), email: \(self.email)")
            self.createGoogleUser(email: self.email!, password: "\(self.email!)")
            
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            guard error == nil else {
                print(error)
                return
            }
            self.googleLogOut()
            print("logout() success.")
            
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
        }
    }
    
    func googleLogOut() {
        try? Auth.auth().signOut()
    }
    
    
}
