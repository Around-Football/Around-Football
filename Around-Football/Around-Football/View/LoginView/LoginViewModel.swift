//
//  LoginViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import Firebase

class LoginViewModel {
    var email: String?
    var password: String?

    func login(completion: @escaping (Bool, Error?) -> Void) {
        guard let email = email, let password = password else {
            completion(false, nil)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
