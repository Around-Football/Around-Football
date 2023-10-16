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
    var id: String
    var fieldAddress: String
    var imageURL: String
    var location: GeoPoint
    
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
        self.fieldAddress = dictionary["fieldAddress"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.location = dictionary["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
    }
}
