//
//  InfoPostViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/11/23.
//

import UIKit

import Kingfisher
import FirebaseAuth
import RxSwift

final class InfoPostViewModel {
    
    weak var coordinator: InfoTabCoordinator?
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let loadPost: Observable<Void>
        let selectedSegment: Observable<Int>? // writtenPostViewController Segment
        
        init(loadPost: Observable<Void>, selectedSegment: Observable<Int>? = nil) {
            self.loadPost = loadPost
            self.selectedSegment = selectedSegment
        }
    }
    
    struct Output {
        let bookmarkList: Observable<[Recruit]>
        let writtenList: Observable<[Recruit]>
        let applicationList: Observable<[Recruit]>
    }
    
    func transform(_ input: Input) -> Output {
        let bookmarkList = loadBookmarkPost(by: input.loadPost)
        let writtenList = loadWrittenPost(by: input.loadPost)
        let selectedWrittenList = emitSelectedSegmentRecruits(selectedSegment: input.selectedSegment, recruits: writtenList)
        let applicationList = loadApplicationPost(by: input.loadPost)
        return Output(bookmarkList: bookmarkList, writtenList: selectedWrittenList, applicationList: applicationList)
    }
    
    private func loadBookmarkPost(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.loadBookmarkPostRx(userID: Auth.auth().currentUser?.uid)
                return recruitObservable
            }
    }
    
    private func loadWrittenPost(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.loadWrittenPostRx(userID: Auth.auth().currentUser?.uid)
                return recruitObservable
            }
    }
    
    private func loadApplicationPost(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.loadApplicationPostRx(userID: Auth.auth().currentUser?.uid)
                return recruitObservable
            }
    }
    
    // MARK: - Kingfisher
    
    func setTitleImage(recruit: Recruit) -> UIImage? {
        return recruit.type == "풋살" ? setFutsalImage(recruit: recruit) : setFootballImage(recruit: recruit)
    }
    
    // MARK: - ImageRender
    private func setFutsalImage(recruit: Recruit) -> UIImage? {
        let imageView = UIImageView()
        let placeHolder = UIImage(named: AFIcon.fieldImage)
        imageView.kf.setImage(with: URL(string:recruit.recruitImages.first ?? AFIcon.defaultImageURL),
                                        placeholder: placeHolder)
        return imageView.image
    }
    
    private func setFootballImage(recruit: Recruit) -> UIImage? {
        let imageView = UIImageView()
        let placeHolder = AFIcon.defaultfootballImage
        imageView.kf.setImage(with: URL(string:recruit.recruitImages.first ?? AFIcon.defaultFootballImageURL),
                                        placeholder: placeHolder)
        return imageView.image
    }
    
    private func emitSelectedSegmentRecruits(selectedSegment: Observable<Int>?, recruits: Observable<[Recruit]>) -> Observable<[Recruit]> {
        return Observable.combineLatest(selectedSegment ?? .just(0), recruits)
            .withUnretained(self)
            .flatMap { (owner, observe) -> Observable<[Recruit]> in
                let index = observe.0
                let recruits = observe.1
                if index == 0 { // 모집 중
                    return .just(recruits.filter {
                        $0.matchDate.dateValue() > Date() && $0.acceptedApplicantsUID.count < $0.pendingApplicantsUID.count
                    })
                } else { // 마감
                    return .just(recruits.filter {
                        $0.matchDate.dateValue() <= Date() || $0.acceptedApplicantsUID.count >= $0.pendingApplicantsUID.count
                    })
                }
            }
    }
    
    // MARK: - Cell 북마크 메서드
    
    func addBookmark(uid: String, recruitID: String?) {
        print("add 눌림")
        FirebaseAPI.shared.fetchUser(uid: uid) { user in
            guard var user = user else { return }
            var bookmark = user.bookmarkedRecruit
            bookmark.append(recruitID)
            user.bookmarkedRecruit = bookmark
            FirebaseAPI.shared.updateUser(user)
        }
    }
    
    func removeBookmark(uid: String, recruitID: String?) {
        print("remove 눌림")
        FirebaseAPI.shared.fetchUser(uid: uid) { user in
            guard var user = user else { return }
            var bookmark = user.bookmarkedRecruit
            bookmark.removeAll { fID in
                recruitID == fID
            }
            user.bookmarkedRecruit = bookmark
            FirebaseAPI.shared.updateUser(user)
        }
    }
    
    func showDetailView(recruit: Recruit) {
        coordinator?.pushDetailCell(recruitItem: recruit)
    }
}
