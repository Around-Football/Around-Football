//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import Foundation

import RxSwift

final class HomeViewModel {
    
    struct Input {
        let loadRecruitList: Observable<RecruitFilter>
    }
    
    struct Output {
        let recruitList: Observable<[Recruit]>
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    weak var coordinator: HomeTabCoordinator?
    
    // MARK: - Lifecycles
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitList = loadRecruitList(by: input.loadRecruitList)
        let output = Output(recruitList: recruitList)
        return output
    }
    
    private func loadRecruitList(by inputObserver: Observable<RecruitFilter>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { input -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.readRecruitRx(input: input)
                return recruitObservable
            }
    }
    
    // MARK: - Cell 북마크 메서드
    
    func addBookmark(uid: String, fieldID: String?) {
        FirebaseAPI.shared.fetchUser(uid: uid) { user in
            var user = user
            var bookmark = user.bookmarkedRecruit
            bookmark.append(fieldID)
            user.bookmarkedRecruit = bookmark
            FirebaseAPI.shared.updateUser(user)
        }
    }
    
    func removeBookmark(uid: String, fieldID: String?) {
        FirebaseAPI.shared.fetchUser(uid: uid) { user in
            var user = user
            var bookmark = user.bookmarkedRecruit
            bookmark.removeAll { fID in
                fieldID == fID
            }
            user.bookmarkedRecruit = bookmark
            FirebaseAPI.shared.updateUser(user)
        }
    }
}
