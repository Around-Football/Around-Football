//
//  FieldDetailViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import Foundation

import RxSwift

final class FieldDetailViewModel {
    
    // MARK: - Properties
    
//    private let field: Field
    private var recruit: Recruit
    private let firebaseAPI = FirebaseAPI.shared
    var playTime: String {
        let startTime = self.recruit.startTime
        let endTime = self.recruit.endTime
        return startTime + "-" + endTime
    }
    var fieldName: String {
        return recruit.fieldName
    }
    var addressLabel: String {
        return recruit.fieldAddress
    }
    var recruitNumber: String {
        let number = self.recruit.recruitedPeopleCount
        return "0 / \(number)"
    }

    // MARK: - Lifecycles

    init(recruit: Recruit) {
        self.recruit = recruit
    }
    // MARK: - API
//    func fetchRecruitFieldData(completion: @escaping(([Recruit]) -> Void)) {
//        firebaseAPI.fetchRecruitFieldData(fieldID: field.id) { recruits in
//            self.recruits = recruits.sorted(by: { $0.matchDateString ?? "0" < $1.matchDateString ?? "1" })
//            completion(recruits)
//        }
//    }
}
