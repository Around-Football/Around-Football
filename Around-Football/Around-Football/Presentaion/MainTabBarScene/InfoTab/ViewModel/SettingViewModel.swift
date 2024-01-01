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
    private let settingMenus = ["알림 설정", "1:1 문의", "약관 및 정책", "로그아웃", "탈퇴"]
    lazy var settingMenusObserverble = Observable.just(settingMenus)

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
