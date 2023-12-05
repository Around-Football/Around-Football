//
//  ChannelAPI.swift
//  Around-Football
//
//  Created by 진태영 on 11/11/23.
//

import Foundation

import Firebase
import FirebaseFirestore
import RxSwift

final class ChannelAPI {
    static let shared = ChannelAPI()
    var listener: ListenerRegistration?
    lazy var channelListener: CollectionReference? = {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return REF_USER.document(uid).collection("channels")
    }()
    
    func fetchChannelInfo(channelId: String) async throws -> ChannelInfo? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        guard let data = try? await REF_USER.document(uid).collection("channels").document(channelId)
            .getDocument().data() else { return nil }
        let channelInfo = ChannelInfo(data)
        
        return channelInfo
    }
    
    
    func createChannel(channel: Channel, owner: User, withUser: User, completion: @escaping () -> Void) {
        let ownerChannel = ChannelInfo(id: channel.id, withUser: withUser)
        let withUserChannel = ChannelInfo(id: channel.id, withUser: owner)
        DB_REF.collection("channels").document(channel.id)
            .setData(channel.representation) {  [weak self] error in
                if let error {
                    print("DEBUG - ", #function, error.localizedDescription)
                    return
                }
                guard let self = self else {
                    print("DEBUG - No self instance", #function)
                    return
                }
                print("DEBUG - ", #function, "createChannel")
                self.addChannelInfo(channelInfo: ownerChannel, owner: owner)
                self.addChannelInfo(channelInfo: withUserChannel, owner: withUser)
                completion()
            }
    }
    
    // User가 참가하는 채팅방 목록 추가
    private func addChannelInfo(channelInfo: ChannelInfo, owner: User) {
        REF_USER.document(owner.id).collection("channels").document(channelInfo.id)
            .setData(channelInfo.representation)
    }
    
    func checkExistAvailableChannel(owner: User, withUser: User, completion: @escaping(Bool, String?) -> Void) {
        REF_USER.document(owner.id).collection("channels")
            .whereField("withUserId", isEqualTo: withUser.id)
            .whereField("isAvailable", isEqualTo: true)
            .getDocuments { snapshot, error in
                guard let isEmpty = snapshot?.isEmpty else {
                    print("DEBUG - snapshot Error", #function, error?.localizedDescription as Any)
                    return
                }
                let isAvailable = !isEmpty
                let documentId = snapshot?.documents.first?.documentID
                completion(isAvailable, documentId)
            }
    }
        
    func subscribe() -> Observable<[(ChannelInfo, DocumentChangeType)]> {
        return Observable.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let self = self,
                  let channelListener = self.channelListener else { return Disposables.create() }
            
            self.listener = channelListener.addSnapshotListener({ snapshot, error in
                print("listen snapshot")
                guard let document = snapshot?.documentChanges else {
                    observer.onError(error ?? NSError(domain: "", code: -1))
                    return
                }
                
                let result = document
                    .filter { ChannelInfo($0.document.data()) != nil }
                    .compactMap { (ChannelInfo($0.document.data())!, $0.type) }
                observer.onNext(result)
            })
            return disposable
        }
    }
    
    /// 채팅 정보 업데이트
    func updateChannelInfo(owner: User, withUser: User, channelId: String, message: Message) {
        var contentMessage: String {
            switch message.kind {
            case .photo(_):
                return "사진"
            case .text(let content):
                return content
            default: return ""
            }
        }
        
        let updateCurrentUserData = [
            "recentDate": message.sentDate,
            "previewContent": contentMessage
        ] as [String: Any]
        
        let updateWithUserData = [
            "recentDate": message.sentDate,
            "previewContent": contentMessage,
            "alarmNumber": FieldValue.increment(Int64(1))
        ] as [String: Any]
        
        let ownerRef = REF_USER.document(owner.id).collection("channels").document(channelId)
        let withUserRef = REF_USER.document(withUser.id).collection("channels").document(channelId)
        updateRefData(ref: ownerRef, data: updateCurrentUserData)
        updateRefData(ref: withUserRef, data: updateWithUserData)
    }
    
    func updateDeleteChannelInfo(withUserId: String, channelId: String) {
        let updateDeleteInfo = [
            "isAvailable": false
        ]
        
        let withUserRef = REF_USER.document(withUserId).collection("channels").document(channelId)
        let channelRef = REF_CHANNELS.document(channelId)
        updateRefData(ref: withUserRef, data: updateDeleteInfo)
        updateRefData(ref: channelRef, data: updateDeleteInfo)
    }
    
    func resetAlarmNumber(uid: String, channelId: String) {
        let ref = REF_USER.document(uid).collection("channels").document(channelId)
        let data = ["alarmNumber": 0]
        updateRefData(ref: ref, data: data)
    }
    
    private func updateRefData(ref: DocumentReference, data: [String: Any]) {
        ref.updateData(data) { error in
            if let error = error {
                print("DEBUG - ", #function, error.localizedDescription)
                return
            }
            print("DEBUG - Document successfully updated", ref.path)
        }
    }
    
    func deleteChannelInfo(uid: String, channelId: String) {
        REF_USER.document(uid).collection("channels").document(channelId).delete()
    }
    
    func deleteChannel(channelId: String) {
        REF_CHANNELS.document(channelId).delete()
    }
    
    func removeListener() {
        listener?.remove()
    }
}
