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
}
