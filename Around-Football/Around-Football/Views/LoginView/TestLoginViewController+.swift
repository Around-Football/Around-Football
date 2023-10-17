//
//  AppleLoginViewController+.swift
//  Around-Football
//
//  Created by 강창현 on 10/16/23.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

// REF: https://developer.apple.com/documentation/sign_in_with_apple/implementing_user_authentication_with_sign_in_with_apple#3546460

extension TestLoginViewController: ASAuthorizationControllerDelegate {
    
    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
    //            guard let nonce = currentNonce else {
    //                fatalError("Invalid state: A login callback was received, but no login request was sent.")
    //            }
    //            guard let appleIDToken = appleIDCredential.identityToken else {
    //                print("Unable to fetch identity token")
    //                return
    //            }
    //            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
    //                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
    //                return
    //            }
    //            // Initialize a Firebase credential, including the user's full name.
    //            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
    //                                                           rawNonce: nonce,
    //                                                           fullName: appleIDCredential.fullName)
    //            // Sign in with Firebase.
    //            Auth.auth().signIn(with: credential) { (authResult, error) in
    //                if let error = error {
    //                    // Error. If error.code == .MissingOrInvalidNonce, make sure
    //                    // you're sending the SHA256-hashed nonce as a hex string with
    //                    // your request to Apple.
    //                    print("Auth.auth().signIn Error: \(error.localizedDescription)")
    //                    return
    //
    //                }
    //
    //                // User is signed in to Firebase with Apple.
    //                // ...
    //            }
    //        }
    //    }
    //
    //    private func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    //        // Handle error.
    //        print("Sign in with Apple errored: \(error)")
    //    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showMainTabViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension TestLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
