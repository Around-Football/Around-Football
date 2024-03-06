//
//  InviteViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

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
        let createDone: Observable<Void>
    }
    
    // MARK: - Properties
    
    private var user: User?
    var recruit: Recruit?
    private var field: Field?
    private var disposeBag = DisposeBag()
    let createButtonSubject = PublishSubject<Void>()
    var fieldID: String = ""
    var location = GeoPoint(latitude: 0, longitude: 0)
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
 
    func uploadRecruit(_ uploadImages: [UIImage?]) {
        let id: String = recruit?.id ?? UUID().uuidString
        StorageAPI.deleteRefImages(id: id) { error in
            if let error = error {
                print("DEBUG - Error deleting file: \(error.localizedDescription)")
                return
            }
            
            self.recruitImages = []
            
            StorageAPI.uploadRecruitImage(images: uploadImages, id: id) { [weak self] urls in
                guard let urls = urls,
                      let self else { return }
                recruitImages = urls.map { $0.absoluteString }
                if self.recruit != nil {    // 수정 중인 경우, recruit가 존재
                    self.updateRecruitData()
                    return
                }
                if self.recruitImages.count == uploadImages.count {    // 글 올리기인 경우
                    self.createRecruitFieldData(id: id)
                }
            }
        }
    }
    
    func createRecruitFieldData(id: String) {
        guard let user = user else { return }
        
        let recruit = Recruit(id: id,
                              userID: user.id,
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
            
//            self.coordinator.popInviteViewController()
            self.createButtonSubject.onNext(())
        }
        
        let field = Field(id: fieldID,
                          fieldName: fieldName.value,
                          fieldAddress: fieldAddress.value,
                          location: location,
                          recruitList: [recruit.id]
        )
        
        FirebaseAPI.shared.createFieldData(field: field, recruit: recruit) { error in
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
        guard let user = user,
              let recruit = recruit else { return }
        let updatedRecruit = Recruit(id: recruit.id,
                              userID: user.id,
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
        FirebaseAPI.shared.updateRecruitData(recruit: updatedRecruit) { error in
            if let error = error {
                print("DEBUG - Error: \(error.localizedDescription)", #function)
            } else {
                print("DEBUG - Update Recruit Data")
            }
            // MARK: - 여기서 뷰컨에 전달
            self.createButtonSubject.onNext(())
//            self.coordinator.popInviteViewController()
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
        let createDone = uploadDone(input: createButtonSubject.asObservable())
        return Output(recruit: recruit, createDone: createDone)
    }
    
    private func uploadDone(input: Observable<Void>) -> Observable<Void> {
        return input.flatMap {
            
            return Observable.just(())
        }
    }
    
    func emitObservableRecruit(by inputObserver: Observable<Void>) -> Observable<Recruit?> {
        inputObserver
            .flatMap { _ -> Observable<Recruit?> in
                guard self.recruit != nil else { return .just(nil) }
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
    
    func downloadImages(imagesURL: [String], completion: @escaping(([UIImage?]) -> Void)) {
        let group = DispatchGroup()
        var images: [UIImage?] = []
        
        for urlString in imagesURL {
            guard let url = URL(string: urlString) else { continue }
            group.enter()
            
            StorageAPI.downloadImage(url: url) { image in
                guard let image = image else { return }
                images.append(image)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
