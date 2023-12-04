//
//  ChannelInfo.swift
//  Around-Football
//
//  Created by 진태영 on 11/11/23.
//

import Foundation

protocol ChannelProtocol {
    var id: String { get }
}

struct Channel: ChannelProtocol {
    let id: String
    let isAvailable: Bool
    var representation: [String: Any] {
        let rep = [
            "id": id,
            "isAvailbale": isAvailable
        ] as [String: Any]
        return rep
    }
    
    init(id: String, isAvailable: Bool) {
        self.id = id
        self.isAvailable = isAvailable
    }
    
    init?(_ dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let isAvailbale = dictionary["isAvailbale"] as? Bool else { return nil }
        self.id = id
        self.isAvailable = isAvailbale
    }
}
