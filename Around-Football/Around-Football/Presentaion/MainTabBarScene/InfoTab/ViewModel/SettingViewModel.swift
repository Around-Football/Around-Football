//
//  SettingViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/27/23.
//

import Foundation

import RxSwift

final class SettingViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: InfoTabCoordinator?

    // MARK: - Lifecycles
    
    init(coordinator: InfoTabCoordinator?) {
        self.coordinator = coordinator
    }
    
    // MARK: - 로그아웃, 회원탈퇴
    
    func logout() {
        UserService.shared.logout()
        coordinator?.popViewController()
    }
    
    func withDraw() {
        UserService.shared.deleteUser()
        coordinator?.popViewController()
    }
}
