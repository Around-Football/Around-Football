//
//  MapModel.swift
//  Around-Football
//
//  Created by 진태영 on 10/6/23.
//

import UIKit

enum LayerID {
    case currentPosition
    case fieldPosition
    
    var description: String {
        switch self {
        case .currentPosition: return "currentPosition"
        case .fieldPosition: return "fieldPosition"
        }
    }
}
// TODO: - Poi 객체 정의하여 PoiID + StyleID 묶기
enum PoiID {
    case currentPosition
    case fieldPosition(String)
    
    var description: String {
        switch self {
        case .currentPosition: return "currentPosition"
        case .fieldPosition(let id): return "\(id)"
        }
    }
}

enum CustomPoiStyle {
    case currentPositionPoiStyle
    case fieldPositionPoiStyle
    
    var id: String {
        switch self {
        case .currentPositionPoiStyle: return "currentPositionPoiStyle"
        case .fieldPositionPoiStyle: return "fieldPositionPoiStyle"
        }
    }
    
    var poiImage: UIImage? {
        switch self {
        case .currentPositionPoiStyle: return UIImage(named: "CurrentPositionMark50")
        case .fieldPositionPoiStyle: return UIImage(named: "CurrentPositionMark50")
        }
    }
}
