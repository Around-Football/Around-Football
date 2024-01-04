//
//  NotificationService.swift
//  Around-Football
//
//  Created by 진태영 on 12/5/23.
//

import Foundation

import Alamofire

final class NotiManager {
    static let shared = NotiManager()
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "key=AAAANwXOQBU:APA91bEe4GiTUDk5CDo_faOh1H_WfTUXz2HLbdFM1EVNWQ26xJVMZd_y7zaBkh-VCW_pOkyqDR5TUZjwiwS5U7OPHGMpoT4Eu3Dr9g16cgqqJvcuaIe_wIyQvOidRr8-vuQOMfr8dho6"
    ]
    
    let fcmUrlString = "https://fcm.googleapis.com/fcm/send"
    
    var currentChatRoomId: String?
    
    private init() { }
    
    func pushChatNotification(channel: Channel, content: String, receiverFcmToken: String, from user: User) {
        let value = [
            "title": user.userName,
            "body": content,
            "sound": "default"
        ]
        let channelIdDictionary = ["channelId": channel.id,
                                   "notificationType": NotificationType.chat.rawValue]
        let params: Parameters = [
            "to": receiverFcmToken,
            "notification": value,
            "data": channelIdDictionary
        ]
        
        let dataRequest = AF.request(fcmUrlString,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        dataRequest.response { response in
            debugPrint(response.data as Any)
        }
        print("DEBUG - ReceiverFCMToken: \(receiverFcmToken)")
    }
    
    func pushApplicantNotification(recruit: Recruit, receiverFcmToken: String) {
        let value = [
            "title": "용병 신청",
            "body": "\(recruit.matchDayAndStartTime) 건에 대한 용병 신청이 접수되었습니다.",
            "sound": "default"
        ]
        
        let dic = ["recruitId": recruit.id,
                   "notificationType": NotificationType.applicant.rawValue]
        
        let params: Parameters = [
            "to": receiverFcmToken,
            "notification": value,
            "data": dic
        ]
        
        let dataRequest = AF.request(fcmUrlString,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        dataRequest.response { response in
            debugPrint(response.data as Any)
        }
        print("DEBUG - ReceiverFCMToken: \(receiverFcmToken)")
    }
    
    func pushAcceptNotification(recruit: Recruit, receiverFcmToken: String) {
        let value = [
            "title": "용병 수락",
            "body": "\(recruit.matchDayAndStartTime) 건에 대한 용병 신청이 수락되었습니다.",
            "sound": "default"
        ]
        
        let dic = ["recruitId": recruit.id,
                   "notificationType": NotificationType.approve.rawValue]
        
        let params: Parameters = [
            "to": receiverFcmToken,
            "notification": value,
            "data": dic
        ]
        
        let dataRequest = AF.request(fcmUrlString,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        dataRequest.response { response in
            debugPrint(response.data as Any)
        }
        print("DEBUG - ReceiverFCMToken: \(receiverFcmToken)")
    }
    
    func pushCancelNotification(recruit: Recruit, receiverFcmToken: String) {
        let value = [
            "title": "용병 취소",
            "body": "\(recruit.matchDayAndStartTime) 용병 승인 건이 취소되었습니다.",
            "sound": "default"
        ]
        
        let dic = ["recruitId": recruit.id,
                   "notificationType": NotificationType.cancel.rawValue]
        
        let params: Parameters = [
            "to": receiverFcmToken,
            "notification": value,
            "data": dic
        ]
        
        let dataRequest = AF.request(fcmUrlString,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        dataRequest.response { response in
            debugPrint(response.data as Any)
        }
        print("DEBUG - ReceiverFCMToken: \(receiverFcmToken)")
    }
}
