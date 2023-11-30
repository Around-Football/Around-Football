//
//  InfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/13/23.
//

import Foundation

final class InfoViewModel {
    
    var user: User?
    
    weak var coordinator: InfoTabCoordinator?
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
    
    func loadFirebaseUserInfo(completion: @escaping (User?) -> Void) {
        FirebaseAPI.shared.readUser { [weak self] user in
            guard let self else { return }
            self.user = user
        }
        
        completion(user)
    }
}
