//
//  InputInfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import Firebase
import RxCocoa
import RxSwift

final class InputInfoViewModel {
    
    struct Input {
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let userInfo: Observable<User?>
    }
    
    weak var coordinator: InputInfoCoordinator?
    private var currentUserRx = UserService.shared.currentUser_Rx
    var inputUserInfo: BehaviorRelay<User>
    var userName: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var age: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var gender: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var area: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var mainUsedFeet: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var position: BehaviorRelay<[String?]> = BehaviorRelay(value: [])
    private var disposeBag = DisposeBag()
    
    init(coordinator: InputInfoCoordinator) {
        self.coordinator = coordinator
        if let user = try? currentUserRx.value() {
            self.inputUserInfo = BehaviorRelay(value: user)
        } else {
            self.inputUserInfo = BehaviorRelay(value: User(dictionary: [:]))
        }
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseAPI.shared.fetchUser(uid: uid) { [weak self] user in
            self?.inputUserInfo.accept(user)
            print("DEBUG - FETCH USER: \(user)")
        }
    }
    
    // MARK: - Helpers
    
    func trensform(_ input: Input) -> Output {
        let userInfo = loadFirebaseUserInfo(by: input.invokedViewWillAppear)
        
        setFirebaseUserInfo(input: userInfo)
        let output = Output(userInfo: userInfo)
        return output
    }
    
    private func loadFirebaseUserInfo(by inputObserver: Observable<Void>) -> Observable<User?> {
        currentUserRx
            .filter { $0 != nil }
            .asObservable()
    }
    
    //기존 데이터 있을때 화면에 뿌려줌
    private func setFirebaseUserInfo(input userInfo: Observable<User?>) {
        userInfo
            .subscribe(onNext: { [weak self] user in
                guard
                    let self,
                    let user
                else { return }
                
                inputUserInfo.accept(user)
                userName.accept(user.userName)
                age.accept(user.age)
                gender.accept(user.gender)
                area.accept(user.area)
                mainUsedFeet.accept(user.mainUsedFeet)
                position.accept(user.position)
            }).disposed(by: disposeBag)
    }
    
    func updateData() {
        let inputData = ["id": inputUserInfo.value.id,
                         "fcmToken": inputUserInfo.value.fcmToken,
                         "userName": userName.value ?? "",
                         "age": age.value ?? "",
                         "gender": gender.value ?? "",
                         "area": area.value ?? "",
                         "mainUsedFeet": mainUsedFeet.value ?? "",
                         "position": position.value] as [String: Any]
        
        // 값 변경할때마다 inputDataObserver로 데이터 보냄
        inputUserInfo.accept(User(dictionary: inputData))
        print("inputData: \(inputData)")
    }
    
}
