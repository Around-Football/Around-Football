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
        "Authorization": "key=AAAANwXOQBU:APA91bEQwxaLVeRdgJso86YO4jvjz2BwvFW9bWtxKrflPAv_gxvNI2QfD38YnvRs7q_YpOp3dcFlVgAvvXOvqwA1pYM2WK04Z1wYJQds7Pq9BKvoGg24jp17I7OPkA-NnjdiqyL9qKOL"
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

}
