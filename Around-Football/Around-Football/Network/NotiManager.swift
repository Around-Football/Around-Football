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
    
    func pushNotification(channel: Channel, content: String, receiverFcmToken: String, from user: User) {
        let value = [
            "title": user.userName,
            "body": content,
            "sound": "default"
        ]
        let channelIdDictionary = ["channelId": channel.id,
                                   "fromUserId": user.id]
        let params: Parameters = [
            "to": receiverFcmToken,
            "notification": value,
            "channelIdDictionary": channelIdDictionary
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
