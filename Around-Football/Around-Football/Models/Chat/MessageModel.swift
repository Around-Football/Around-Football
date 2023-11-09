//
//  Message.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import MessageKit
import Firebase

struct Message: MessageType {
    let id: String
    let sender: SenderType
    let content: String
    var image: UIImage?
    var downloadURL: URL?
    let sentDate: Date
    var kind: MessageKit.MessageKind {
        if let image = image {
            let mediaItem = ImageMediaItem(image: image)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    var representation: [String : Any] {
        var representation: [String: Any] = [
            "id": id,
            "created": sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            representation["url"] = url.absoluteString
        } else {
            representation["content"] = content
        }
        
        return representation
    }

    
    // create text message
    init(user: User, content: String) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        self.content = content
        sentDate = Date()
        id = UUID().uuidString
    }
    
    // create image message
    init(user: User, image: UIImage) {
        sender = Sender(senderId: user.uid, displayName: user.userName)
        self.image = image
        sentDate = Date()
        content = ""
        id = UUID().uuidString
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let sentDate = dictionary["created"] as? Timestamp,
              let senderId = dictionary["senderId"] as? String,
              let senderName = dictionary["senderName"] as? String else { return nil }
        
        self.id = id
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        
        if let content = dictionary["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = dictionary["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
