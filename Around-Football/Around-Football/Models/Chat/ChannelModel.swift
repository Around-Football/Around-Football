//
//  ChannelModel.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

import Firebase

struct Channel {
    let id: String?
    let toUserName: String
    let toUserId: String
    let recentDate: Date
    let previewContent: String
    let alarmNumber: Int
    var representation: [String: Any] {
        let rep = [
            "id": id ?? UUID().uuidString,
            "toUserId": toUserId,
            "toUserName": toUserName,
            "recentDate": recentDate,
            "alarmNumber": alarmNumber,
            "previewContent": previewContent
        ] as [String: Any]
        
        return rep
    }
    
    // Create Channel Init
    init(id: String? = nil, toUser: User) {
        self.id = id
        self.toUserId = toUser.id
        self.toUserName = toUser.userName
        self.recentDate = Date()
        self.previewContent = ""
        self.alarmNumber = 0
    }
    
    // subscribe ChannelInit
    init?(_ dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
              let toUserName = dictionary["toUserName"] as? String,
              let recentDate = dictionary["recentDate"] as? Timestamp,
              let toUserId = dictionary["toUserId"] as? String,
              let previewContent = dictionary["previewContent"] as? String,
              let alarmNumber = dictionary["alarmNumber"] as? Int else { return nil }
        
        self.recentDate = recentDate.dateValue()
        
        self.id = id
        self.toUserId = toUserId
        self.toUserName = toUserName
        self.previewContent = previewContent
        self.alarmNumber = alarmNumber
    }
}

extension Channel: Comparable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.recentDate > rhs.recentDate
    }
}
