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
    let messageId: String
    let sender: SenderType
    let content: String
    var image: UIImage?
    var downloadURL: URL?
    let sentDate: Date
    var showTimeLabel: Bool = false
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
            "messageId": messageId,
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
        messageId = UUID().uuidString
    }
    
    // create image message
    init(user: User, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        self.image = image
        sentDate = Date()
        content = ""
        messageId = UUID().uuidString
    }
    
    init?(dictionary: [String: Any]) {
        guard let messageId = dictionary["messageId"] as? String,
              let sentDate = dictionary["created"] as? Timestamp,
              let senderId = dictionary["senderId"] as? String,
              let senderName = dictionary["senderName"] as? String else { return nil }
        
        self.messageId = messageId
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
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
