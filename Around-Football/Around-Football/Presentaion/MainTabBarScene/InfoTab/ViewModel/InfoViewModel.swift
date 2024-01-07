//
//  InfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/13/23.
//

import Foundation

import RxSwift

final class InfoViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: InfoTabCoordinator?
    var user: User?
    private let menus = ["내 정보 수정", "관심 글", "신청 글", "작성 글"]
    lazy var menusObservable = Observable.just(menus)
    
    // MARK: - Lifecycles
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
}
