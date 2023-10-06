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
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "App_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일"
        $0.borderStyle = .roundedRect
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
    }
    
    private let loginButton = UIButton().then {
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
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(named: "pointColor"), for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private let signUpStackView = UIStackView().then {
        //        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        //        $0.spacing = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        configureUI()
        
        if navigationController == nil {
            let navigationController = UINavigationController(rootViewController: self)
        }
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
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 필수 정보가 입력되지 않았을 때 처리할 코드
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                // 로그인 실패 시 처리할 코드
                print("로그인 실패: \(error.localizedDescription)")
            } else {
                // 로그인 성공 시 처리할 코드
                print("로그인 성공")
                // 예를 들어 로그인 후 화면 전환 등을 수행할 수 있습니다.
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TextField가 편집 모드에 들어갈 때 화면을 위로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 200, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TextField에서 편집이 끝날 때 화면을 원래 위치로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Return 키를 누를 때 다음 TextField로 포커스 이동
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}





//#Preview {
//    var controller = LoginViewController()
//    return controller
//}
