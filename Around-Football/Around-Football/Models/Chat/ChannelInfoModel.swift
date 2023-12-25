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
    let recruitID: String
    let alarmNumber: Int
    let isAvailable: Bool
    var representation: [String: Any] {
        let rep = [
            "id": id,
            "withUserId": withUserId,
            "withUserName": withUserName,
            "recentDate": recentDate,
            "alarmNumber": alarmNumber,
            "previewContent": previewContent,
            "recruitID": recruitID,
            "isAvailable": isAvailable
        ] as [String: Any]
        
        return rep
    }
    
    // Create ChannelInfo Init
    init(id: String, withUser: User, recruitID: String) {
        self.id = id
        self.withUserId = withUser.id
        self.withUserName = withUser.userName
        self.recentDate = Date()
        self.previewContent = ""
        self.recruitID = recruitID
        self.alarmNumber = 0
        self.isAvailable = true
    }
    
    // subscribe ChannelInfoInit
    init?(_ dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
              let withUserId = dictionary["withUserId"] as? String,
              let withUserName = dictionary["withUserName"] as? String,
              let recentDate = dictionary["recentDate"] as? Timestamp,
              let previewContent = dictionary["previewContent"] as? String,
              let recruitID = dictionary["recruitID"] as? String,
              let alarmNumber = dictionary["alarmNumber"] as? Int,
              let isAvailable = dictionary["isAvailable"] as? Bool else { return nil }
        
        self.recentDate = recentDate.dateValue()
        
        self.id = id
        self.withUserId = withUserId
        self.withUserName = withUserName
        self.previewContent = previewContent
        self.recruitID = recruitID
        self.alarmNumber = alarmNumber
        self.isAvailable = isAvailable
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
