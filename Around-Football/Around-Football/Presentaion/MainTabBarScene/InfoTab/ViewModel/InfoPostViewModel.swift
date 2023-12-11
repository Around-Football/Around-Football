//
//  InfoPostViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/11/23.
//

import Foundation

import FirebaseAuth
import RxSwift

final class InfoPostViewModel {
    
    weak var coordinator: InfoTabCoordinator?
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let loadPost: Observable<Void>
    }
    
    struct Output {
        let bookmarkList: Observable<[Recruit]>
        let writtenList: Observable<[Recruit]>
    }
    
    func transform(_ input: Input) -> Output {
        let bookmarkList = loadBookmarkPost(by: input.loadPost)
        let writtenList = loadWrittenPost(by: input.loadPost)
        return Output(bookmarkList: bookmarkList, writtenList: writtenList)
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
    
    private func loadApplicationPost() {
        
    }
    
}
