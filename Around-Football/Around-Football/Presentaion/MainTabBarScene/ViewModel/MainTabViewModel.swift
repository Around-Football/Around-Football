//
//  MainTabViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift

final class MainTabViewModel {
    let user: BehaviorSubject<User?> = UserService.shared.currentUser_Rx
}
