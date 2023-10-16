//
//  AppleLoginViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/16/23.
//

import AuthenticationServices
import UIKit

import SnapKit
import Then

class AppleLoginViewController: UIViewController {
    
    private lazy var authorizationButton = ASAuthorizationAppleIDButton().then {
        $0.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    private lazy var loginProviderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
        $0.addArrangedSubview(authorizationButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(loginProviderStackView)
        view.backgroundColor = .white
        loginProviderStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
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
        
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


