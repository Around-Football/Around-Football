//
//  InviteViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

final class InviteViewModel {
    
    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator) {
        self.coordinator = coordinator
    }

    func createRecruitFieldData(user: User?,
                                 fieldID: String,
                                 recruitedPeopleCount: Int,
                                 content: String?,
                                 matchDate: String?,
                                 startTime: Date?,
                                 endTime: Date?) {
        // MARK: - 테스트용 임시 데이터 파베에 올림
        FirebaseAPI.shared.createRecruitFieldData(user: user,
                                                  fieldID: fieldID,
                                                  recruitedPeopleCount: recruitedPeopleCount,
                                                  content: content,
                                                  matchDate: matchDate,
                                                  startTime: startTime,
                                                  endTime: endTime) { error in
            if error == nil {
                print("필드 올리기 성공")
                //TODO: - coordinator로 변경
//                coordinator
            } else {
                print("createRecruitFieldData Error: \(error?.localizedDescription)")
            }
        }
    }
}
