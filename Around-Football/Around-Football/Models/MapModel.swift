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
        case .currentPosition: return UIImage(named: AFIcon.trackingPoint)
        case .fieldPosition(_): return UIImage(named: AFIcon.marker)
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

enum Poi {
    case currentPosition
    case fieldPosition([String])
}
