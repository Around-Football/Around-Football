//
//  Field.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import CoreLocation
import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Field: Codable, Identifiable {
    var id: String //운동장ID(추가)
    var fieldName: String //운동장 이름
    var fieldAddress: String //운동장 주소
    var location: GeoPoint //운동장 좌표
    var recruitList: [String]
    
    var representation: [String: Any] {
        let rep = ["id": id,
                   "fieldName": fieldName,
                   "fieldAddress": fieldAddress,
                   "location": location,
                   "recruitList": recruitList
                   ] as [String : Any]
        return rep
    }
    
    init(
        id: String,
        fieldName: String,
        fieldAddress: String,
        location: GeoPoint,
        recruitList: [String]
    ) {
        self.id = id
        self.fieldName = fieldName
        self.fieldAddress = fieldAddress
        self.location = location
        self.recruitList = recruitList
    }
    
    init(
        dictionary: [String: Any]
    ) {
        self.id = dictionary["id"] as? String ?? ""
        self.fieldName = dictionary["fieldName"] as? String ?? ""
        self.fieldAddress = dictionary["fieldAddress"] as? String ?? ""
        self.location = dictionary["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
        self.recruitList = dictionary["recruitList"] as? [String] ?? []
    }
}
