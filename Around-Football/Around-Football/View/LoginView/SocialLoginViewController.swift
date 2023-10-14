//
//  SocialLoginViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/14/23.
//

import UIKit

import FirebaseAuth
import SnapKit
import Then
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class SocialLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Selectors
    
    @objc func kakaoLoginButtonTapped() {
//        isInstalledKakao()
        hasToken()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubviews(kakaoLoginButton)
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - KakaoLogin 관련 함수

extension SocialLoginViewController {
    //로그인시
    func hasToken() {
        let hasToken = AuthApi.hasToken()
        switch hasToken {
        case true:
            UserApi.shared.accessTokenInfo { (_, error) in
                guard error == nil else {
                    //로그인 필요
                    self.kakaoLogin()
                    return
                }
            }
            //자동로그인
            accessTokenInfo()
        case false: //로그인 필요
            //로그인 필요
            isInstalledKakao()
            print("로그인 요청")
        }
    }
    
    //회원가입시 회원가입 방식 2가지
    func isInstalledKakao() {
        print("loginKakao() called.")
        // 카카오톡 설치 여부 확인
        let isKakaoAppInstalled = UserApi.isKakaoTalkLoginAvailable()

        switch isKakaoAppInstalled {
        case true: //카카오톡 설치되어 있을때
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                print("loginWithKakaoTalk() success.")
                
                //TODO: -  회원가입 성공 시 oauthToken 저장
                _ = oauthToken
                
                UserApi.shared.me { user, error in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    guard
                        let user = user,
                        let userId = user.id,
                        let userEmail = user.kakaoAccount?.email
                    else {
                        print("유저 가져오기 오류")
                        return
                    }

                    self.createGoogleUser(email: userEmail, password: "\(userId)")
                }
                
                // 완료 후 모달 내리기
                self.dismiss(animated: true)
            }
        case false: //카톡 미설치, 카카오 계정으로 로그인
            print("카카오톡 미설치")
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
                
                //완료후 모달 내리기
                self.dismiss(animated: true)
            }
        }
        
    }
    
    //추가항목 필요할때
    //1. 동의 구하기
    func requestAdditionalAgreement() {
        UserApi.shared.me() { [weak self] (user, error) in
            guard let self else { return }
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let user = user else {
                print(error?.localizedDescription as Any)
                return
            }
            
            var scopes = [String]()
            scopes.append("openid") //openid사용시 무조건 추가! ID토큰 재발급
            //필요한 추가항목들 걸러서 쓰기
            if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
            if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
            if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
            if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
            if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
            if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
            if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
            if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }
            
            if scopes.count > 0 {
                print("사용자에게 추가 동의를 받아야 합니다.")
                requestKakaoLogin(with: scopes)
            }
            else {
                print("사용자의 추가 동의가 필요하지 않습니다.")
            }
        }
        
    }
    
    //2. scope 목록을 전달하여 카카오 로그인 요청
    func requestKakaoLogin(with scopes: [String]) {

        UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            self.kakaoLogin()
        }
    }
    
    //3. 로그인
    func kakaoLogin() {
        UserApi.shared.me() { (user, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            print("me() success.")
            
            //do something
            _ = user
            print("접속유저: \(user)")
            
            self.dismiss(animated: true)
        }
    }
    
    //로그아웃
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("logout() success.")
        }
    }
    
    // 사용자 액세스 토큰 정보 조회
    func accessTokenInfo() {
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("accessTokenInfo() success.")
            
            //do something
            _ = accessTokenInfo
            print("\(accessTokenInfo)")
        }
    }
}

// MARK: - 파베 로그인 관련

extension SocialLoginViewController {
    //파베 유저 생성
    private func createGoogleUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            self.googleSignIn(email: email, password: password) //회원가입 완료
        }
    }
    
    //구글 로그인
    private func googleSignIn(email: String, password: String) {
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
