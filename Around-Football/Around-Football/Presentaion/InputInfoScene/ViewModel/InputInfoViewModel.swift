//
//  InputInfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift

final class InputInfoViewModel {
    
    private var currentUserRx = UserService.shared.currentUser_Rx
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let userInfo: Observable<User?>
    }
    
    weak var coordinator: InputInfoCoordinator?
    
    init(coordinator: InputInfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func trensform(_ input: Input) -> Output {
        let userInfo = loadFirebaseUserInfo(by: input.invokedViewWillAppear)
        
        let output = Output(userInfo: userInfo)
        return output
    }
    
    private func loadFirebaseUserInfo(by inputObserver: Observable<Void>) -> Observable<User?> {
        currentUserRx
            .filter { $0 != nil }
            .asObservable()
    }
}
