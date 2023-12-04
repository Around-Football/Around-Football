//
//  LoginViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/14/23.
//

import AuthenticationServices
import UIKit

import FirebaseAuth
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel?
    private var disposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        bindLogin()
    }
    
    // MARK: - Selectors
    
    @objc
    func kakaoLoginButtonTapped() {
        UserService.shared.kakaoSignIn()
    }
    
    @objc
    func googleLoginButtonTapped() {
        UserService.shared.googleSignIn(self)
    }
    
    @objc
    func appleLoginButtonTapped() {
        UserService.shared.appleSignIn()
    }
    
    // MARK: - Helpers
    
    private func bindLogin() {
        UserService.shared.isLoginObservable
            .do(onNext: { [weak self]_ in
                guard let self else { return }
                do {
                    let name = try UserService.shared.currentUser_Rx.value()?.userName
                    if name == "" {
                        print("유저 네임 없음. input뷰로 이동")
                        viewModel?.coordinator?.pushInputInfoViewController()
                    } else {
                        print("유저 네임 있음. 로그인 완료")
                        viewModel?.coordinator?.loginDone()
                    }
                } catch {
                    print("로그인 오류")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
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
