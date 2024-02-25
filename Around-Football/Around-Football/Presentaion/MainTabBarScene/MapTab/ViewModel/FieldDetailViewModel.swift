//
//  FieldDetailViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import Foundation

final class FieldDetailViewModel {
    
    // MARK: - Properties
    
    private let field: Field
    private var recruits: [Recruit] = []
    private let firebaseAPI = FirebaseAPI.shared

    // MARK: - Lifecycles
    
    init(field: Field) {
        self.field = field
    }
    
    // MARK: - API
    
    func fetchRecruitFieldData(completion: @escaping(([Recruit]) -> Void)) {
        firebaseAPI.fetchRecruitFieldData(fieldID: field.id) { recruits in
//            self.recruits = recruits.sorted(by: { $0.matchDateString ?? "0" < $1.matchDateString ?? "1" })
            completion(recruits)
        }
    }
}
