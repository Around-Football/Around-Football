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
    
    var kakaoLoginService = KakaoLoginService()
    
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
        kakaoLoginService.onKakaoLoginByAppTouched()
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
