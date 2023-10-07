//
//  SignUpViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import UIKit

import SnapKit
import Then

class SignUpViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black
        // FIXME: - LargeTitle + Bold 구현
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요."
        $0.borderStyle = .roundedRect
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.borderStyle = .roundedRect
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    lazy var textFieldDelegateHandler = TextFieldDelegateHandler(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = textFieldDelegateHandler
        passwordTextField.delegate = textFieldDelegateHandler
        textFieldDelegateHandler.nextTextField = passwordTextField
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.equalTo(emailTextField)
            make.width.equalTo(emailTextField)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(passwordTextField)
            make.width.equalTo(passwordTextField)
        }
    }
    
    @objc func signUpButtonTapped() {
    // TODO: - 추가정보 뷰 연결
//        let nextVC = NextViewController()
//        navigationController?.pushViewController(nextVC, animated: true)
        print("signUpButtonTapped!")
    }
}
