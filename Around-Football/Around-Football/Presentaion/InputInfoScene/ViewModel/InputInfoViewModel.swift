//
//  InputInfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift

class InputInfoViewModel {
    
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
        let userObserver = Observable.create { observer in
            let user = UserService.shared.user
            observer.onNext(user)
            observer.onCompleted()
            return Disposables.create()
        }
        
        return userObserver
    }
}
