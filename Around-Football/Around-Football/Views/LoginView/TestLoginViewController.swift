//
//  AppleLoginViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/16/23.
//

import AuthenticationServices
import CryptoKit
import UIKit

import SnapKit
import Then
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class TestLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentNonce: String?
    
    private var loginViewModel = LoginViewModel()
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "App_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var goggleLoginButton = GIDSignInButton().then {
        $0.style = .iconOnly
        $0.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var authorizationButton = ASAuthorizationAppleIDButton().then {
        $0.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    private lazy var loginProviderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
        $0.addArrangedSubviews(goggleLoginButton,
                               authorizationButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        
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
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
        }
    }
    
    // Apple Login SetUp
    func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "changhyun-kyle.Around-Football", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    func showMainTabViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        guard let viewController = self.presentingViewController as? MainTabController
        else { return }
        
        DispatchQueue.main.async {
            //                    viewController.userIdentifierLabel.text = userIdentifier
            //                    if let givenName = fullName?.givenName {
            //                        viewController.givenNameLabel.text = givenName
            //                    }
            //                    if let familyName = fullName?.familyName {
            //                        viewController.familyNameLabel.text = familyName
            //                    }
            //                    if let email = email {
            //                        viewController.emailLabel.text = email
            //                    }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Google Login SetUp
    @objc private func googleLoginButtonTapped() {
        loginViewModel.login()
//        loginViewModel.login { success, error in
////            guard let self else { return }
//            if success {
//                print("로그인 성공")
////                guard let viewController = self?.presentingViewController as? MainTabController else { return }
////                
////                DispatchQueue.main.async {
////                    viewController.dismiss(animated: true, completion: nil)
////                }
//                // 예를 들어 로그인 후 화면 전환 등을 수행할 수 있습니다.
//            } else {
//                if let error = error {
//                    print("로그인 실패: \(error.localizedDescription)")
//                }
//            }
//        }
    }
}


