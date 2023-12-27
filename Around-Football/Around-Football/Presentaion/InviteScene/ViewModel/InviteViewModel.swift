//
//  InviteViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import Firebase
import RxCocoa
import RxSwift

final class InviteViewModel {
    
    private var user: User?
    private var disposeBag = DisposeBag()
    
    private var fieldID = UUID().uuidString
    var fieldName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var fieldAddress: BehaviorRelay<String> = BehaviorRelay(value: "")
    var region: BehaviorRelay<String> = BehaviorRelay(value: "")
    var type: BehaviorRelay<String> = BehaviorRelay(value: "")
    var gamePrice: BehaviorRelay<String> = BehaviorRelay(value: "")
    var peopleCount: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var contentTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
    var content: BehaviorRelay<String> = BehaviorRelay(value: "")
    var matchDateString: BehaviorRelay<String> = BehaviorRelay(value: "")
    var matchDate: BehaviorRelay<Timestamp> = BehaviorRelay(value: Timestamp(date: Date()))
    var startTime: BehaviorRelay<String> = BehaviorRelay(value: "")
    var endTime: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let pendingApplicantsUID: [String] = []
    private let acceptedApplicantsUID: [String] = []
    
    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator) {
        self.coordinator = coordinator
        setUser()
    }
    
    private func setUser() {
        UserService.shared.currentUser_Rx.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.user = user
        })
        .disposed(by: disposeBag)
    }
    
    func createRecruitFieldData() {
        // MARK: - 테스트용 임시 데이터 파베에 올림
        guard let user = user else { return }
        let recruit = Recruit(userID: user.id, 
                              userName: user.userName,
                              fieldID: fieldID,
                              fieldName: fieldName.value,
                              fieldAddress: fieldAddress.value,
                              region: region.value,
                              type: type.value,
                              recruitedPeopleCount: peopleCount.value,
                              gamePrice: gamePrice.value,
                              title: contentTitle.value,
                              content: content.value,
                              matchDate: matchDate.value,
                              startTime: startTime.value,
                              endTime: endTime.value,
                              matchDateString: matchDateString.value,
                              pendingApplicantsUID: pendingApplicantsUID,
                              acceptedApplicantsUID: acceptedApplicantsUID)
        
        FirebaseAPI.shared.createRecruitFieldData(recruit: recruit) { error in
            if error == nil {
                print("DEBUG - 필드 올리기 성공")
                //TODO: - 성공 알림창 띄워주기?
            } else {
                print("DEBUG - createRecruitFieldData Error: \(String(describing: error?.localizedDescription))")
                //TODO: - 실패 알림창 띄워주기?
            }
        }
    }
}
