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
    private let smallLogo = UIImageView(image: UIImage(named: AFIcon.smallLogo))
    private let backgroundView = UIImageView(image: UIImage(named: AFIcon.loginBackgroundImage))
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "App_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let loginMent = UILabel().then {
        $0.text = "내 주변 빠른 용병 찾기"
        $0.font = AFFont.titleRegular
        $0.textColor = AFColor.secondary
    }
    
    private lazy var appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.appleLogin), for: .normal)
        $0.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var googleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.googleLogin), for: .normal)
        $0.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.kakaoLogin), for: .normal)
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var loginProviderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 15
        $0.addArrangedSubviews(appleLoginButton,
                               googleLoginButton,
                               kakaoLoginButton)
    }
    
    private lazy var closeButton = UIButton(type: .custom).then {
        let image = UIImage(named: AFIcon.closeButton)
        image?.withTintColor(AFColor.grayScale200, renderingMode: .alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: LoginViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindInputUserData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func bindInputUserData() {
        UserService.shared.checkUserInfoExist.subscribe(onNext: { [weak self] bool in
            guard let self else { return }
            if bool == true {
                do {
                    let name = try UserService.shared.currentUser_Rx.value()?.userName
                    if name == nil || name == "" {
                        print("유저 네임 없음. input뷰로 이동")
                        viewModel?.coordinator?.pushInputInfoViewController()
                    } else {
                        print("유저 네임 있음. 로그인 완료")
                        viewModel?.coordinator?.loginDone()
                    }
                } catch {
                    print("로그인 오류")
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        view.backgroundColor = .white
        view.addSubviews(backgroundView,
                         smallLogo,
                         logoImageView,
                         loginMent,
                         loginProviderStackView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        smallLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(125)
            make.width.equalTo(40)
            make.height.equalTo(50)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(smallLogo.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(58)
            make.trailing.equalToSuperview().offset(-58)
        }
        
        loginMent.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(18)
        }
        
        loginProviderStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginMent.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(180)
        }
    }
}
