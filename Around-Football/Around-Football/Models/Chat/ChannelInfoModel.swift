//
//  ChannelModel.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

import Firebase

struct ChannelInfo: ChannelProtocol {
    let id: String
    let withUserId: String
    let withUserName: String
    let recentDate: Date
    let previewContent: String
    let alarmNumber: Int
    var representation: [String: Any] {
        let rep = [
            "id": id,
            "withUserId": withUserId,
            "withUserName": withUserName,
            "recentDate": recentDate,
            "alarmNumber": alarmNumber,
            "previewContent": previewContent
        ] as [String: Any]
        
        return rep
    }
    
    // Create ChannelInfo Init
    init(id: String? = nil, withUser: User) {
        self.id = UUID().uuidString
        self.withUserId = withUser.id
        self.withUserName = withUser.userName
        self.recentDate = Date()
        self.previewContent = ""
        self.alarmNumber = 0
    }
    
    // subscribe ChannelInfoInit
    init?(_ dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
              let withUserId = dictionary["withUserId"] as? String,
              let withUserName = dictionary["withUserName"] as? String,
              let recentDate = dictionary["recentDate"] as? Timestamp,
              let previewContent = dictionary["previewContent"] as? String,
              let alarmNumber = dictionary["alarmNumber"] as? Int else { return nil }
        
        self.recentDate = recentDate.dateValue()
        
        self.id = id
        self.withUserId = withUserId
        self.withUserName = withUserName
        self.previewContent = previewContent
        self.alarmNumber = alarmNumber
    }
}

extension ChannelInfo: Comparable {
    static func == (lhs: ChannelInfo, rhs: ChannelInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: ChannelInfo, rhs: ChannelInfo) -> Bool {
        return lhs.recentDate > rhs.recentDate
    }
}
