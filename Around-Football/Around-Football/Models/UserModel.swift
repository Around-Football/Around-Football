//
//  UserModel.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/23/23.
//

import Foundation

struct User {
    var id: String
    var userName: String
    var age: Int
    var contact: Int?
    var detailSex: String
    var area: String
    var mainUsedFeet: String
    var position: String
    
    //TODO: - 연락방식 채팅..?, 쪽지..?, 상남자식 번호..?
    
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
        self.contact = dictionary["contact"] as? Int ?? Int()
        self.detailSex = dictionary["detailSex"] as? String ?? ""
        self.area = dictionary["area"] as? String ?? ""
        self.mainUsedFeet = dictionary["mainUsedFeet"] as? String ?? ""
        self.position = dictionary["position"] as? String ?? ""
    }
}

