//
//  ChannelAPI.swift
//  Around-Football
//
//  Created by 진태영 on 11/11/23.
//

import Foundation

import Firebase
import FirebaseFirestore

final class ChannelAPI {
    static let shared = ChannelAPI()
    var listener: ListenerRegistration?
    lazy var channelListener: CollectionReference? = {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return REF_USER.document(uid).collection("channels")
    }()
    
    
    func createChannel(channel: Channel, owner: User, withUser: User, completion: @escaping () -> Void) {
        let ownerChannel = ChannelInfo(id: channel.id, withUser: withUser)
        let withUserChannel = ChannelInfo(withUser: owner)
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
    
    func checkExistChannel(owner: User, withUser: User, completion: @escaping(Bool, String?) -> Void) {
        REF_USER.document(owner.id).collection("channels")
            .whereField("withUserId", isEqualTo: withUser.id)
            .getDocuments { snapshot, error in
                guard let isEmpty = snapshot?.isEmpty else {
                    print("DEBUG - snapshot Error", #function, error?.localizedDescription as Any)
                    return
                }
                let isExist = !isEmpty
                let documentId = snapshot?.documents.first?.documentID
                completion(isExist, documentId)
            }
    }
    
    func subscribe(completion: @escaping (Result<[(ChannelInfo, DocumentChangeType)], Error>) -> Void) {
        guard let channelListener = channelListener else { return }
        channelListener.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            let result = snapshot.documentChanges
                .filter { ChannelInfo($0.document.data()) != nil }
                .compactMap { (ChannelInfo($0.document.data())!, $0.type) }
            
            completion(.success(result))
        }
    }
    
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
        
        let updateChannelInfo = [
            "recentDate": message.sentDate,
            "previewContent": contentMessage
        ] as [String: Any]
        
        let ownerRef = REF_USER.document(owner.id).collection("channels").document(channelId)
        let withUserRef = REF_USER.document(withUser.id).collection("channels").document(channelId)
        updateRefData(ref: ownerRef, data: updateChannelInfo)
        updateRefData(ref: ownerRef, data: updateChannelInfo)
        
    }
    
    func resetAlarmNumber(uid: String, channelId: String) {
        let ref = REF_USER.document(uid).collection("channels").document(channelId)
        let data = ["alarmNumber": 0]
        updateRefData(ref: ref, data: data)
            
    }
    
    // TODO: - Firebase 공통 API에 넣어버리기
    private func updateRefData(ref: DocumentReference, data: [String: Any]) {
        ref.updateData(data) { error in
            if let error = error {
                print("DEBUG - ", #function, error.localizedDescription)
                return
            }
            print("DEBUG - Document successfully updated")
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
