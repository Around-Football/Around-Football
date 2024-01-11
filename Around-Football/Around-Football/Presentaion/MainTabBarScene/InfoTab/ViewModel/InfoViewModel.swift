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
    
//    struct Output {
//        let userProfileImageURL: Observable<[String]>
//    }
    
    func uploadImage(_ input: Input){
        setUserProfileImage(by: input.setUserProfileImage)
    }
    
    private func setUserProfileImage(by inputObserver: Observable<UIImage>) {
        inputObserver
            .subscribe { [weak self] input in
                guard let self else { return }
                guard var user else { return }
                StorageAPI.uploadImage(image: input, id: user.id) { [weak self] url in
                    guard let self else { return }
                    print( url?.absoluteString ?? "")
                    user.profileImageUrl = url?.absoluteString ?? ""
                    FirebaseAPI.shared.updateUser(user)
                }
            }
            .disposed(by: disposeBag)
    }
}
