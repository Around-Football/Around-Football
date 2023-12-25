//
//  FieldDetailViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/13/23.
//

import Foundation

final class FieldDetailViewModel {
    
    // MARK: - Properties
    
    let field: Field
    let selectedDate: Date
    private var recruits: [Recruit] = []
    private let firebaseAPI = FirebaseAPI.shared

    // MARK: - Lifecycles
    
    init(field: Field, selectedDate: Date) {
        self.field = field
        self.selectedDate = selectedDate
    }
    
    // MARK: - API
    
    func fetchRecruitFieldData(date: Date, completion: @escaping(([Recruit]) -> Void)) {
        firebaseAPI.fetchRecruitFieldData(fieldID: field.id, date: date) { recruits in
            //TODO: -Date sort
//            self.recruits = recruits.sorted(by: { $0.matchDateString ?? "0" < $1.matchDateString ?? "1" })
            
            completion(recruits)
        }
    }
    
    
}
