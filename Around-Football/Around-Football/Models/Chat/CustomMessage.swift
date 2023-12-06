//
//  CustomMessage.swift
//  Around-Football
//
//  Created by 진태영 on 12/6/23.
//

import Foundation

import Firebase
import MessageKit

struct DateMessage: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var content: String
    var kind: MessageKit.MessageKind {
        return .custom(content)
    }
    var representation: [String : Any] {
        var representation: [String: Any] = [
            "messageId": messageId,
            "created": sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        return representation
    }

    
    // create message
    init(user: User) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        messageId = UUID().uuidString
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"

        let dateString = formatter.string(from: date)
        sentDate = date
        content = dateString
    }
        
    init?(dictionary: [String: Any]) {
        guard let messageId = dictionary["messageId"] as? String,
              let sentDate = dictionary["created"] as? Timestamp,
              let senderId = dictionary["senderId"] as? String,
              let senderName = dictionary["senderName"] as? String,
              let content = dictionary["content"] as? String else { return nil }
        
        self.messageId = messageId
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        self.content = content
    }
}

extension DateMessage: Comparable {
    static func == (lhs: DateMessage, rhs: DateMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: DateMessage, rhs: DateMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
