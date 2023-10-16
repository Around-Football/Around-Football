//
//  Recruit.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import Foundation

struct Recruit: Codable, Identifiable {
    var id: String
    var username: String
    var people: String
    var content: String
    var matchDate: Date
    // TODO: - 시작 시간, 종료 시간 데이터 추가, fieldID
    
    static func convertToArray(documents: [[String: Any]]) -> [Recruit] {
        var array: [Recruit] = []
        for document in documents {
            let recruit = Recruit(dictionary: document)
            array.append(recruit)
        }
        
        return array
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.username = dictionary["username"] as? String ?? ""
        self.people = dictionary["people"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.matchDate = dictionary["matchDate"] as? Date ?? Date()
    }
}

