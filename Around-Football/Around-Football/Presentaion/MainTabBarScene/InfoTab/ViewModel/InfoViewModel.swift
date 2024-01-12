//
//  InfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/13/23.
//

import UIKit

import RxSwift

final class InfoViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: InfoTabCoordinator?
    var user: User?
    private let menus = ["내 정보 수정", "관심 글", "신청 글", "작성 글"]
    lazy var menusObservable = Observable.just(menus)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let setUserProfileImage: Observable<UIImage>
    }
    
    struct Output {
        let userProfileImageURL: Observable<String>
    }
    
    func uploadImage(_ input: Input) -> Output {
        let url = setUserProfileImage(by: input.setUserProfileImage)
        
        return Output(userProfileImageURL: url)
    }
    
    private func setUserProfileImage(by inputObserver: Observable<UIImage>) -> Observable<String> {
        inputObserver
            .flatMap { [weak self] input -> Observable<String> in
                guard let self else {
                    print("self없음")
                    return Observable.empty()
                }
                guard var user else {
                    print("user없음")
                    return Observable.empty()
                }
                
                StorageAPI.uploadImage(image: input, id: user.id) { url in
                    print( url?.absoluteString ?? "")
                    user.profileImageUrl = url?.absoluteString ?? ""
                    FirebaseAPI.shared.updateUser(user)
                }
                
                return Observable.just(user.profileImageUrl)
            }
    }
}
