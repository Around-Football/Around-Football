//
//  InviteViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxCocoa
import RxSwift

final class InviteViewModel {
    
    private var user: User?
    private var id: String?
    private var userName: String?
    private var disposeBag = DisposeBag()
    
    private var fieldID = UUID().uuidString
    var fieldName: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var fieldAddress: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var region: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var type: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var gamePrice: BehaviorRelay<String?> = BehaviorRelay(value: "")
    private let pendingApplicantsUID: [String?] = []
    private let acceptedApplicantsUID: [String?] = []

    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator) {
        self.coordinator = coordinator
        setUser()
    }
    
    private func setUser() {
        UserService.shared.currentUser_Rx.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.user = user
            self.id = user?.id
            self.userName = user?.userName
        })
        .disposed(by: disposeBag)
    }
    
    func createRecruitFieldData(peopleCount: Int,
                                contentTitle: String?,
                                content: String?,
                                matchDateString: String?,
                                startTime: String?,
                                endTime: String?) {
        // MARK: - 테스트용 임시 데이터 파베에 올림
        FirebaseAPI.shared.createRecruitFieldData(user: user,
                                                  fieldID: fieldID,
                                                  fieldName: fieldName.value ?? "",
                                                  fieldAddress: fieldAddress.value ?? "",
                                                  region: region.value ?? "",
                                                  type: type.value ?? "",
                                                  recruitedPeopleCount: peopleCount,
                                                  gamePrice: gamePrice.value ?? "",
                                                  title: contentTitle,
                                                  content: content,
                                                  matchDateString: matchDateString,
                                                  startTime: startTime,
                                                  endTime: endTime,
                                                  pendingApplicantsUID: pendingApplicantsUID,
                                                  acceptedApplicantsUID: acceptedApplicantsUID) { error in
            if error == nil {
                print("필드 올리기 성공")
                //TODO: - 성공 알림창 띄워주기?
            } else {
                print("createRecruitFieldData Error: \(String(describing: error?.localizedDescription))")
                //TODO: - 실패 알림창 띄워주기?
            }
        }
    }
}
