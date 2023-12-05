//
//  UserModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/23/23.
//

import Foundation

struct User: Codable {
    var id: String
    var userName: String
    var age: Int
    var gender: String
    var area: String
    var mainUsedFeet: String
    var position: [String]
    //TODO: - FCM Token 추가
    var fcmToken: String
    
    static func convertToArray(documents: [[String: Any]]) -> [User] {
        var array: [User] = []
        for document in documents {
            let user = User(dictionary: document)
            array.append(user)
        }
        
        return array
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.userName = dictionary["userName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? Int()
        self.gender = dictionary["gender"] as? String ?? ""
        self.area = dictionary["area"] as? String ?? ""
        self.mainUsedFeet = dictionary["mainUsedFeet"] as? String ?? ""
        self.position = dictionary["position"] as? [String] ?? []
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
    }
}
