//
//  LoginViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/14/23.
//

import AuthenticationServices
import UIKit

import FirebaseAuth
import SnapKit
import Then
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

protocol LoginViewControllerDelegate: AnyObject {
    func pushToInputInfoViewController()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: LoginViewControllerDelegate?
    private var loginViewModel = LoginViewModel()
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "App_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        let image = UIImage(named: "KakaoLogin")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var appleLoginButton = UIButton().then {
        let image = UIImage(named: "AppleLogin")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var googleLoginButton = UIButton().then {
        let image = UIImage(named: "GoogleLogin")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        $0.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var loginProviderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 20
        $0.addArrangedSubviews(googleLoginButton,
                               kakaoLoginButton,
                               appleLoginButton)
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        // TODO: - Coordinator Refactoring
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRecieveTestNotification(_:)),
                                               name: NSNotification.Name("TestNotification"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    
    @objc func didRecieveTestNotification(_ notification: Notification) {
            print("Test Notification")
//        let inputInfoViewController = InputInfoViewController()
//        self.navigationController?.pushViewController(inputInfoViewController, animated: true)
        delegate?.pushToInputInfoViewController()
    }
    
    @objc func kakaoLoginButtonTapped() {
        loginViewModel.kakaoSignIn()
    }
    
    @objc func googleLoginButtonTapped() {
        loginViewModel.googleSignIn(self)
    }
    
    @objc func appleLoginButtonTapped() {
        loginViewModel.appleSignIn()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .white
        view.addSubviews(logoImageView,
                         loginProviderStackView)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        loginProviderStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(60)
        }
    }
}