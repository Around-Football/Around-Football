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
    let members: Int
    var representation: [String: Any] {
        let rep = [
            "id": id,
            "members": members
        ] as [String: Any]
        return rep
    }
}
