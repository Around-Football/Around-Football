//
//  ChannelViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

import FirebaseFirestore
import Firebase

final class ChannelViewModel {
    
    // MARK: - Properties
    
    var channels: [ChannelInfo] = []
    var currentUser: User?
    
    // MARK: - API
    
    func setupListener() {
        ChannelAPI.shared.subscribe { [weak self] result in
            switch result {
            case .success(let data):
            case .failure(let error):
                print("DEBUG - setupListener Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser() {
        let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken) { [weak self] user, error in
            if let error = error {
                print("DEBUG - FetchUser Error: ", #function, error.localizedDescription)
                return
            }
            guard let self = self else { return }
            self.currentUser = user
            print("DEBUG - CurrentUser: \(String(describing: self.currentUser))")

        }
    }
    // MARK: - Helpers
    
}
