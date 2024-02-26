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
    
    private var recruits: [Recruit]
    private let firebaseAPI = FirebaseAPI.shared
    var recruitsCount: Int {
        return recruits.count
    }
    
    // MARK: - Lifecycles

    init(recruits: [Recruit]) {
        self.recruits = recruits
    }
    
    // MARK: - Helpers
    
    func fetchRecruit(row: Int) -> Recruit {
        return self.recruits[row]
    }
    
    func fetchFieldData() -> Recruit? {
        guard let fieldData = recruits.first else { return nil }
        return fieldData
    }
    
    // MARK: - API
//    func fetchRecruitFieldData(completion: @escaping(([Recruit]) -> Void)) {
//        firebaseAPI.fetchRecruitFieldData(fieldID: field.id) { recruits in
//            self.recruits = recruits.sorted(by: { $0.matchDateString ?? "0" < $1.matchDateString ?? "1" })
//            completion(recruits)
//        }
//    }
}
