//
//  UserModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/23/23.
//

import Foundation

import Firebase

struct User: Codable {
    var id: String = Auth.auth().currentUser?.uid ?? ""
    var userName: String
    var age: String
    var gender: String
    var area: String
    var mainUsedFeet: String
    var position: [String]
    var fcmToken: String
    var bookmarkedRecruit: [String?] //북마크한 필드id 저장
    var totalAlarmNumber: Int = 0
    
    var representation: [String: Any] {
        let rep = [
            "id": id,
            "userName": userName,
            "age": age,
            "gender": gender,
            "area": area,
            "mainUsedFeet": mainUsedFeet,
            "position": position,
            "fcmToken": fcmToken,
            "bookmarkedRecruit": bookmarkedRecruit,
            "totalAlarmNumber": totalAlarmNumber
        ] as [String: Any]
        
        return rep
    }
    
    init(dictionary: [String: Any]) {
        // MARK: - 여기서 이상한 UUID를 넣어줘서 연동이 안됐었음
//        self.id = dictionary["id"] as? String ?? "여기"
        self.userName = dictionary["userName"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.area = dictionary["area"] as? String ?? ""
        self.mainUsedFeet = dictionary["mainUsedFeet"] as? String ?? ""
        self.position = dictionary["position"] as? [String] ?? []
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
        self.bookmarkedRecruit = dictionary["bookmarkedRecruit"] as? [String] ?? []
        self.totalAlarmNumber = dictionary["totalAlarmNumber"] as? Int ?? 0
    }
}
