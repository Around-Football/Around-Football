//
//  MapModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/6/23.
//

import UIKit

struct MapLabel {
    let labelType: LabelType
    let poi: Poi
    
    var layerID: String {
        switch self .labelType {
        case .currentPosition: return "currentLayer"
        case .fieldPosition: return "fieldLayer"
        }
    }
    
    var poiID: [String] {
        switch self.poi {
        case .currentPosition: return ["currentPosition"]
        case .fieldPosition(let id): return id
        }
    }
    
    var poiImage: UIImage? {
        switch self.poi {
        case .currentPosition: return UIImage(named: "CurrentPositionMark")
        case .fieldPosition(_): return UIImage(named: "FieldPositionMark")
        }
    }
    
    var poiStyle: String {
        switch self.poi {
        case .currentPosition: return "currentPositionPoiStyle"
        case .fieldPosition(_): return "fieldPositionPoiStyle"
        }
    }
    
    var poiRank: Int {
        switch self.poi {
        case .currentPosition: return 0
        case .fieldPosition(_): return 1
        }
    }
}

enum LabelType {
    case currentPosition
    case fieldPosition
}
// TODO: - Poi 객체 정의하여 PoiID + StyleID 묶기
enum Poi {
    case currentPosition
    case fieldPosition([String])
}

//enum GuiButtonComponent: String {
//    case trackingPosition
//    
//    var name: String {
//        switch self {
//        case .trackingPosition: return "trackingPosition"
//        }
//    }
//}

struct Place: Codable {
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
