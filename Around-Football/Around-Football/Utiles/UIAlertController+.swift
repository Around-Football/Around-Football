//
//  UIAlertController+.swift
//  Around-Football
//
//  Created by 진태영 on 12/5/23.
//

import UIKit

extension UIAlertController {
    enum AlertCase {
        case deleteChannel
        
        var title: String {
            switch self {
            case .deleteChannel: return "채널채팅방 나가기"
            }
        }
        
        var message: String {
            switch self {
            case .deleteChannel: return "나가기를 하면 대화내용이 모두 삭제되고 채팅 목록에서도 삭제됩니다."
            }
        }
    }
    
    convenience init(title: UIAlertController.AlertCase, message: UIAlertController.AlertCase, preferredStyle: UIAlertController.Style) {
        self.init(title: title.title, message: message.message, preferredStyle: preferredStyle)
    }
}
