//
//  Recruit.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import Foundation

struct Recruit: Codable {
    let id: Int
    let userName: String
    let people: Int
    let content, matchDate, matchTime, fieldName: String
    let fieldAddress: String

    enum CodingKeys: String, CodingKey {
        case id, userName, people, content, matchDate, matchTime
        case fieldName = "FieldName"
        case fieldAddress = "FieldAddress"
    }
}
