//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import CryptoKit

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

class LoginViewModel {
    
    // MARK: - Properties
    
    private var userProfile: String?
    private var email: String?
    var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    
}
