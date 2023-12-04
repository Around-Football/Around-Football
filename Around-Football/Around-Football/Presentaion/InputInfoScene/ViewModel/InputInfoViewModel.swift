//
//  InputInfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxCocoa
import RxSwift

final class InputInfoViewModel {
    
    private var currentUserRx = UserService.shared.currentUser_Rx
    var inputUserInfo: BehaviorRelay<User> = BehaviorRelay(value: User(dictionary: [:]))
    var userName: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var age: BehaviorRelay<Int?> = BehaviorRelay(value: 0)
    var gender: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var area: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var mainUsedFeet: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var position: BehaviorRelay<[String?]> = BehaviorRelay(value: [])
    private var disposeBag = DisposeBag()
    
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
        
        //처음 값 세팅
        userInfo
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                
                if let user = user {
                    self.inputUserInfo.accept(user)
                    self.userName.accept(user.userName)
                    self.age.accept(user.age)
                    self.gender.accept(user.gender)
                    self.area.accept(user.area)
                    self.mainUsedFeet.accept(user.mainUsedFeet)
                    self.position.accept(user.position)
                } else {
                    // Handle the case when user is nil, if needed
                }
            }).disposed(by: disposeBag)
        
        let output = Output(userInfo: userInfo)
        return output
    }
    
    private func loadFirebaseUserInfo(by inputObserver: Observable<Void>) -> Observable<User?> {
        currentUserRx
            .filter { $0 != nil }
            .asObservable()
    }
    
    func updateData() {
        let inputData = ["userName": userName.value ?? "",
                         "age": age.value ?? 0,
                         "gender": gender.value ?? "",
                         "area": area.value ?? "",
                         "mainUsedFeet": mainUsedFeet.value ?? "",
                         "position": position.value] as [String: Any]
        
        // 값 변경할때마다 inputDataObserver로 데이터 보냄
        inputUserInfo.accept(User(dictionary: inputData))
        print("inputData: \(inputData)")
    }
    
}
