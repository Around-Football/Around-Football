//
//  Message.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import MessageKit
import Firebase

enum CustomMessageType: String {
    case chat
    case date
    case inform
}

struct Message: MessageType {
    let messageId: String
    let sender: SenderType
    let content: String
    var image: UIImage?
    var downloadURL: URL?
    let sentDate: Date
    var showTimeLabel: Bool = true
    var messageType: CustomMessageType
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
            "senderName": sender.displayName,
            "messageType": messageType.rawValue
        ]
        
        if let url = downloadURL {
            representation["url"] = url.absoluteString
        } else {
            representation["content"] = content
        }
        
        return representation
    }
    
    // create message
    init(user: User, content: String, messageType: CustomMessageType) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        sentDate = Date()
        messageId = UUID().uuidString
        self.messageType = messageType
        switch messageType {
        case .chat: self.content = content
        case .date:
            let date = sentDate
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
            
            let dateString = formatter.string(from: date)
            self.content = dateString
        case .inform:
            self.content = "\(sender.displayName)님이 채팅방을 나가셨습니다.\n상대방이 메시지를 확인할 수 없습니다."
        }
    }
    
    init?(dictionary: [String: Any]) {
        guard let messageId = dictionary["messageId"] as? String,
              let sentDate = dictionary["created"] as? Timestamp,
              let senderId = dictionary["senderId"] as? String,
              let senderName = dictionary["senderName"] as? String,
              let messageType = dictionary["messageType"] as? String else { return nil }
        
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
        
        if CustomMessageType.chat.rawValue == messageType {
            self.messageType = .chat
        } else if CustomMessageType.date.rawValue == messageType {
            self.messageType = .date
        } else {
            self.messageType = .inform
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

// MARK: - ChatMessage
extension Message {
    // create image message
    init(user: User, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        self.image = image
        sentDate = Date()
        content = ""
        messageId = UUID().uuidString
        messageType = .chat
    }
}
