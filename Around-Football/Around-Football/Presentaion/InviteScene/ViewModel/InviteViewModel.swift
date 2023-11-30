//
//  InviteViewModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import Foundation

import RxSwift

final class InviteViewModel {
    
    var coordinator: InviteCoordinator
    
    init(coordinator: InviteCoordinator) {
        self.coordinator = coordinator
    }
    
    func createRecruitFieldData(user: User?,
                                fieldID: String,
                                fieldName: String,
                                fieldAddress: String,
                                region: String,
                                type: String?,
                                recruitedPeopleCount: Int,
                                gamePrice: String,
                                title: String?,
                                content: String?,
                                matchDateString: String?,
                                startTime: String?,
                                endTime: String?) {
        // MARK: - 테스트용 임시 데이터 파베에 올림
        FirebaseAPI.shared.createRecruitFieldData(user: user,
                                                  fieldID: fieldID,
                                                  fieldName: fieldName,
                                                  fieldAddress: fieldAddress,
                                                  region: region,
                                                  type: type,
                                                  recruitedPeopleCount: recruitedPeopleCount,
                                                  gamePrice: gamePrice,
                                                  title: title,
                                                  content: content,
                                                  matchDateString: matchDateString,
                                                  startTime: startTime,
                                                  endTime: endTime) { error in
            if error == nil {
                print("필드 올리기 성공")
                //TODO: - 성공 알림창 띄워주기?
            } else {
                print("createRecruitFieldData Error: \(error?.localizedDescription)")
                //TODO: - 실패 알림창 띄워주기?
            }
        }
    }
}
