//
//  InfoViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/13/23.
//

import Foundation

final class InfoViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: InfoTabCoordinator?
    var user: User?
    var menus = ["내 정보 수정", "관심 글", "신청 글", "작성 글"]

    // MARK: - Lifecycles
    
    init(coordinator: InfoTabCoordinator) {
        self.coordinator = coordinator
    }
    
}
