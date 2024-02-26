//
//  SearchModel.swift
//  Around-Football
//
//  Created by 강창현 on 11/13/23.
//

import Foundation

struct Place: Codable, Hashable {
    let id: String
    let name: String
    let address: String
    let x: String
    let y: String
}

struct KakaoPlaceResponse: Codable {
    let documents: [PlaceData]
}

struct PlaceData: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}
