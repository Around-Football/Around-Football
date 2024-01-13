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
    
    // MARK: - Type
    
    struct Input {
        let recruitImages: Observable<[UIImage]>
    }
    
    struct Output {
        let recruit: Observable<Recruit>
    }
    
    // MARK: - Properties
    
    private var user: User?
    private var recruit: Recruit?
    private var disposeBag = DisposeBag()
    
    private var fieldID = UUID().uuidString
    var fieldName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var fieldAddress: BehaviorRelay<String> = BehaviorRelay(value: "")
    var region: BehaviorRelay<String> = BehaviorRelay(value: "")
    var type: BehaviorRelay<String> = BehaviorRelay(value: "")
    var gamePrice: BehaviorRelay<String> = BehaviorRelay(value: "")
    var gender: BehaviorRelay<String> = BehaviorRelay(value: "")
    var peopleCount: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var contentTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
    var content: BehaviorRelay<String> = BehaviorRelay(value: "")
    var matchDateString: BehaviorRelay<String> = BehaviorRelay(value: "")
    var matchDate: BehaviorRelay<Timestamp> = BehaviorRelay(value: Timestamp(date: Date()))
    var startTime: BehaviorRelay<String> = BehaviorRelay(value: "")
    var endTime: BehaviorRelay<String> = BehaviorRelay(value: "")
    var recruitImages: [String] = []
    private let pendingApplicantsUID: [String] = []
    private let acceptedApplicantsUID: [String] = []
    
    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator) {
        self.coordinator = coordinator
        setUser()
    }
    
    // MARK: - Helpers
    
    private func setUser() {
        UserService.shared.currentUser_Rx.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.user = user
        })
        .disposed(by: disposeBag)
    }
    
    func setRecruitImages(_ uploadImages: BehaviorSubject<[UIImage?]>) {
        uploadImages
            .subscribe { [weak self] input in
                guard let self = self else { return }
                
                StorageAPI.uploadRecruitImage(images: input) { [weak self] url in
                    guard let url = url,
                          let self else { return }
                    recruitImages.append(url.absoluteString)
                    if self.recruitImages.count == input.count {
                        self.createRecruitFieldData()
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    func showPHPickerView(picker: UIViewController) {
        coordinator.presentPHPickerView(picker: picker)
    }
    
    func createRecruitFieldData() {
        guard let user = user else { return }
        let recruit = Recruit(userID: user.id,
                              userName: user.userName,
                              fieldID: fieldID,
                              fieldName: fieldName.value,
                              fieldAddress: fieldAddress.value,
                              region: region.value,
                              type: type.value,
                              gender: gender.value,
                              recruitedPeopleCount: peopleCount.value,
                              gamePrice: gamePrice.value,
                              title: contentTitle.value,
                              content: content.value,
                              matchDate: matchDate.value,
                              startTime: startTime.value,
                              endTime: endTime.value,
                              matchDateString: matchDateString.value,
                              pendingApplicantsUID: pendingApplicantsUID,
                              acceptedApplicantsUID: acceptedApplicantsUID,
                              recruitImages: recruitImages)
        
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
