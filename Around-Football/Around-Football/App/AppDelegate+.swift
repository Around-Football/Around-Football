//
//  AppDelegate+.swift
//  Around-Football
//
//  Created by 진태영 on 12/5/23.
//

import Foundation

import Firebase
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // MARK: Push Tab Handler
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("DEBUG - Tap push notification", #function)
        
        if NotificationType.chat.rawValue == response.notification.request.content.userInfo["notificationType"] as? String {
            guard let id = response.notification.request.content.userInfo["channelId"] as? String else {
                print("DEBUG - Push Noti on the app, No ChatRoomId", #function)
                return
            }
//            deepLinkChatView(channelId: channelId)
            deepLinkHandler(id: id, notificationType: .chat)
        }
        
        if NotificationType.applicant.rawValue == response.notification.request.content.userInfo["notificationType"] as? String {
            guard let id = response.notification.request.content.userInfo["recruitId"] as? String else {
                print("DEBUG - Push Noti on the app, No RecruitId", #function)
                return
            }
//            deepLinkDetailView(recruitId: recruitId)
            deepLinkHandler(id: id, notificationType: .applicant)
        }
        
    }
    
    private func deepLinkHandler(id: String, notificationType: NotificationType) {
        guard Auth.auth().currentUser?.uid != nil else { return }
        Task {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let appCoordinator = sceneDelegate.appCoordinator,
                let mainTabBarCoordinator = appCoordinator
                    .childCoordinators
                    .first(where: { $0 is MainTabBarCoordinator }) as? MainTabBarCoordinator
            else { return }

            do {
                switch notificationType {
                case .chat:
                    guard let channelInfo = try await ChannelAPI.shared.fetchChannelInfo(channelId: id) else {
                        throw NSError(domain: "ChannelInfo Fetch Error", code: -1)
                    }
                    //채팅뷰로 이동
                    mainTabBarCoordinator.handleChatDeepLink(channelInfo: channelInfo)
                case .applicant:
                    guard let recruit = try await FirebaseAPI.shared.fetchRecruit(recruitID: id) else {
                        throw NSError(domain: "Recruit Fetch Error", code: -1)
                    }
                    mainTabBarCoordinator.handleApplicantListDeepLink(recruit: recruit)
                case .approve: break
                }
            } catch(let error as NSError) {
                print("DEBUG - Tap Push Notification Error", error.localizedDescription)
            }
        }
    }
    
    // Present Notification after receiving Push Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("DEBUG - Notification UserInfo", notification.request.content.userInfo)
        guard let channelId = notification.request.content.userInfo["channelId"] as? String,
              Auth.auth().currentUser != nil else {
            print("DEBUG - Push Notification on the app, No ChatRoomId", #function)
            return [.sound, .banner, .list]
        }
        
        if NotiManager.shared.currentChatRoomId == channelId {
            // 현재 활성화된 채팅방이 알림의 채팅방과 동일하다면, 알림 표시 안함
            print("CurrentChatRoom Noti", #function)
            if let uid = Auth.auth().currentUser?.uid {
                ChannelAPI.shared.resetAlarmNumber(uid: uid, channelId: channelId)
            }
            return []
        }
        
        // 현재 활성화된 View가 알림의 채팅방 View가 아니라면, 알림 표시
        print("DEBUG - Push Notification on App, Not match View", #function)
        
        return [.sound, .banner, .list]
    }
    
    // FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG - FCM Token Messaging", #function, fcmToken ?? "")
        guard let fcmToken = fcmToken else { return }
        UserDefaults.standard.setValue(fcmToken, forKey: "FCMToken")
    }
    
    // 스위즐링 No시 APNs 등록, 토큰 값 가져옴
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("DEBUG - APNS 등록, deviceToken", #function, deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG - NotificationError", error)
    }
    
}
