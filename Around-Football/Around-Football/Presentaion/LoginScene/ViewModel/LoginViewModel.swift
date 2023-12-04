//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import AuthenticationServices
import CryptoKit
import Foundation

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseCore
import GoogleSignIn

final class LoginViewModel {
    
    // MARK: - Properties

    private var email: String?
    var coordinator: LoginCoordinator?
    
    // MARK: - Lifecycles
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
}
