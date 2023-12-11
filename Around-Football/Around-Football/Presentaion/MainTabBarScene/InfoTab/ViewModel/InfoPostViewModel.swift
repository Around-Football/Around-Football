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
        let loadBookmarkPost: Observable<Void>
    }
    
    struct Output {
        let bookmartPost: Observable<[Recruit]>
    }
    
    func transform(_ input: Input) -> Output {
        let bookmarkList = loadBookmarkPost(by: input.loadBookmarkPost)
        
        return Output(bookmartPost: bookmarkList)
    }
    
    private func loadBookmarkPost(by inputObserver: Observable<Void>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { () -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.loadBookmarkPostRx(userID: Auth.auth().currentUser?.uid)
                return recruitObservable
            }
    }
    
    private func loadWrittenPost() {
        
    }
    
    private func loadApplicationPost() {
        
    }
    
}
