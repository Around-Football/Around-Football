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
}
