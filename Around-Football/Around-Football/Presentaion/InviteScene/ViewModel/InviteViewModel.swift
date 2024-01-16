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
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let recruit: Observable<Recruit?>
    }
    
    // MARK: - Properties
    
    private var user: User?
    var recruit: Recruit?
    private var field: Field?
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
    private var pendingApplicantsUID: [String] = []
    private var acceptedApplicantsUID: [String] = []
    
    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator, recruit: Recruit? = nil) {
        self.coordinator = coordinator
        self.recruit = recruit
        setUser()
        setEditRecruit()
    }
    
    // MARK: - API
    
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
    
    func updateRecruitData() {
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
        FirebaseAPI.shared.updateRecruitData(recruit: recruit) { error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
            } else {
                print("DEBUG - Update Recruit Data")
            }
        }
    }

    // MARK: - Helpers
    
    private func setUser() {
        UserService.shared.currentUser_Rx.subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.user = user
        })
        .disposed(by: disposeBag)
    }
    
    private func setEditRecruit() {
        guard let recruit = recruit else { return }
        fieldID = recruit.fieldID
        fieldName.accept(recruit.fieldName)
        fieldAddress.accept(recruit.fieldAddress)
        region.accept(recruit.region)
        type.accept(recruit.type)
        gamePrice.accept(recruit.gamePrice)
        gender.accept(recruit.gender)
        peopleCount.accept(recruit.recruitedPeopleCount)
        contentTitle.accept(recruit.title)
        content.accept(recruit.content)
        matchDateString.accept(recruit.matchDateString)
        matchDate.accept(recruit.matchDate)
        startTime.accept(recruit.startTime)
        endTime.accept(recruit.endTime)
        recruitImages = recruit.recruitImages
        pendingApplicantsUID = recruit.pendingApplicantsUID
        acceptedApplicantsUID = recruit.acceptedApplicantsUID
    }
    
    
    func showPHPickerView(picker: UIViewController) {
        coordinator.presentPHPickerView(picker: picker)
    }
    
    func transform(input: Input) -> Output {
        let recruit = emitObservableRecruit(by: input.invokedViewWillAppear)
        return Output(recruit: recruit)
    }
    
    func emitObservableRecruit(by inputObserver: Observable<Void>) -> Observable<Recruit?> {
        inputObserver
            .flatMap { _ -> Observable<Recruit?> in
                guard let recruit = self.recruit else { return .just(nil) }
                return .just(self.recruit)
            }
    }
    
    func shortDateFormatter() -> DateFormatter {
        let titleDateformatter = DateFormatter()
        titleDateformatter.locale = Locale(identifier: "ko_KR")
        titleDateformatter.dateFormat = "M월 d일"
        
        return titleDateformatter
    }
    
    func stringToTimeFormatter(timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // Locale을 "ko_KR"로 설정
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // TimeZone을 한국 시간으로 설정
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: timeString)
    }
    
    
    func setSelectedTime(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24시간 형식의 시간과 분만 표시
        let result = dateFormatter.string(from: input)
        print(result)
        return result
    }
}
