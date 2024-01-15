//
//  Field.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Field: Codable, Identifiable {
    var id: String //운동장ID(추가)
    var fieldName: String //운동장 이름
    var fieldAddress: String //운동장 주소
//    var imageURL: String //운동장 이미지
    var location: GeoPoint //운동장 좌표
    
    static func convertToArray(documents: [[String: Any]]) -> [Field] {
        var array: [Field] = []
        for document in documents {
            let field = Field(dictionary: document)
            array.append(field)
        }
        
        return array
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.fieldName = dictionary["fieldName"] as? String ?? ""
        self.fieldAddress = dictionary["fieldAddress"] as? String ?? ""
//        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.location = dictionary["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
    }
}
