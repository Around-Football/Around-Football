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
    let withUserGender: String
    let withUserAge: String
    let withUserArea: String
    let withUserMainUsedFeet: String
    let withUserPosition: [String]
    let recentDate: Date
    var image: UIImage?
    var downloadURL: URL?
    let previewContent: String
    let recruitID: String
    let recruitUserID: String
    let alarmNumber: Int
    let isAvailable: Bool
    var representation: [String: Any] {
        var rep = [
            "id": id,
            "withUserId": withUserId,
            "withUserName": withUserName,
            "withUserGender": withUserGender,
            "withUserAge": withUserAge,
            "withUserArea": withUserArea,
            "withUserMainUsedFeet": withUserMainUsedFeet,
            "withUserPosition": withUserPosition,
            "recentDate": recentDate,
            "alarmNumber": alarmNumber,
            "previewContent": previewContent,
            "recruitID": recruitID,
            "recruitUserID": recruitUserID,
            "isAvailable": isAvailable
        ] as [String: Any]
        
        if let url = downloadURL {
            rep["downloadURL"] = url.absoluteString
        }
        
        return rep
    }
    
    // Create ChannelInfo Init
    init(id: String, withUser: User, recruitID: String, recruitUserID: String) {
        self.id = id
        self.withUserId = withUser.id
        self.withUserName = withUser.userName
        self.withUserGender = withUser.gender
        self.withUserAge = withUser.age
        self.withUserArea = withUser.area
        self.withUserMainUsedFeet = withUser.mainUsedFeet
        self.withUserPosition = withUser.position        
//        self.downloadURL = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/around-football.appspot.com/o/8930189C-6983-4A48-9E02-321C8484897E%2F846FF6B7-454F-4EAB-8C43-89DD402FE0D21703843637.667433?alt=media&token=5e8c3184-0dba-4cec-8b04-910c8e3c03e0")
        self.recentDate = Date()
        self.previewContent = ""
        self.recruitID = recruitID
        self.recruitUserID = recruitUserID
        self.alarmNumber = 0
        self.isAvailable = true
        if let url = URL(string: withUser.profileImageUrl) {
            self.downloadURL = url
        }
    }
    
    // subscribe ChannelInfoInit
    init?(_ dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
              let withUserId = dictionary["withUserId"] as? String,
              let withUserName = dictionary["withUserName"] as? String,
              let withUserGender = dictionary["withUserGender"] as? String,
              let withUserAge = dictionary["withUserAge"] as? String,
              let withUserArea = dictionary["withUserArea"] as? String,
              let withUserMainUsedFeet = dictionary["withUserMainUsedFeet"] as? String,
              let withUserPosition = dictionary["withUserPosition"] as? [String],
              let recentDate = dictionary["recentDate"] as? Timestamp,
              let previewContent = dictionary["previewContent"] as? String,
              let recruitID = dictionary["recruitID"] as? String,
              let recruitUserID = dictionary["recruitUserID"] as? String,
              let alarmNumber = dictionary["alarmNumber"] as? Int,
              let isAvailable = dictionary["isAvailable"] as? Bool else { return nil }
        
        self.recentDate = recentDate.dateValue()
        
        self.id = id
        self.withUserId = withUserId
        self.withUserName = withUserName
        self.withUserGender = withUserGender
        self.withUserAge = withUserAge
        self.withUserArea = withUserArea
        self.withUserMainUsedFeet = withUserMainUsedFeet
        self.withUserPosition = withUserPosition
        self.previewContent = previewContent
        self.recruitID = recruitID
        self.recruitUserID = recruitUserID
        self.alarmNumber = alarmNumber
        self.isAvailable = isAvailable
        if let urlString = dictionary["downloadURL"] as? String, let url = URL(string: urlString) {
            self.downloadURL = url
        }
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
