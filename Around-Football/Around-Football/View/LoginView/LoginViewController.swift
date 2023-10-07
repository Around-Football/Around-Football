//
//  LoginViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//
// 로그인
import Foundation
import UIKit
import SnapKit
import Then
import Firebase

class LoginViewController: UIViewController {
    
    private var loginViewModel = LoginViewModel()
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "App_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "이메일"
        $0.borderStyle = .roundedRect
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
    }
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private let signUpLabel = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = .black
        $0.backgroundColor = .clear
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(named: "pointColor"), for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private let signUpStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    lazy var textFieldDelegateHandler = TextFieldDelegateHandler(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldDelegateHandler = TextFieldDelegateHandler(viewController: self)
        emailTextField.delegate = textFieldDelegateHandler
        passwordTextField.delegate = textFieldDelegateHandler
        textFieldDelegateHandler.nextTextField = passwordTextField
        
        configureUI()
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.width.equalTo(emailTextField)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(emailTextField)
        }
        
        view.addSubview(signUpStackView)
        // 버튼과 Label을 StackView에 추가하고 제약 조건 설정
        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        signUpStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
    }
    
    // MARK: - 로그인 버튼 Tap
    @objc private func loginButtonTapped() {
        loginViewModel.email = emailTextField.text
        loginViewModel.password = passwordTextField.text
        
        loginViewModel.login { [weak self] success, error in
            if success {
                print("로그인 성공")
                // 예를 들어 로그인 후 화면 전환 등을 수행할 수 있습니다.
            } else {
                if let error = error {
                    print("로그인 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - 회원가입 버튼 Tap
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
        print("signUpButtonTapped!")
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}

//#Preview {
//    var controller = LoginViewController()
//    return controller
//}
