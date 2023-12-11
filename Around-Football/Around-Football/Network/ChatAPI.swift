//
//  ChatAPI.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import Foundation

import RxSwift
import FirebaseFirestore

final class ChatAPI {
    static let shared = ChatAPI()
    var chatListener: ListenerRegistration?
    var chatStatusListener: ListenerRegistration?
    var collectionListenerRef: CollectionReference?
    var statusListenerRef: DocumentReference?
    
    func chatSubscribe(id: String) -> Observable<[Message]> {
        
        removeChatListener()
        collectionListenerRef = REF_CHANNELS.document(id).collection("thread")
        
        return Observable.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let self = self else { return Disposables.create() }
            
            self.chatListener = collectionListenerRef?
                .addSnapshotListener({ snapshot, error in
                    guard let snapshot = snapshot else {
                        observer.onError(error ?? NSError(domain: "", code: -1))
                        return
                    }
                    var messages: [Message] = []
                    snapshot.documentChanges.forEach { change in
                        if let message = Message(dictionary: change.document.data()) {
                            if case .added = change.type {
                                messages.append(message)
                            }
                        }
                    }
                    observer.onNext(messages)
                })
            return disposable
        }
    }
    
    func chatStatusSubscribe(id: String, completion: @escaping(Result<Channel, StreamError>) -> Void){
        removeChatStatusListener()
        statusListenerRef = REF_CHANNELS.document(id)
        chatStatusListener = statusListenerRef?.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(StreamError.firestoreError(error)))
                return
            }
            guard let data = snapshot.data() else {
                completion(.failure(StreamError.firestoreError(error)))
                return
            }
            
            guard let channel = Channel(data) else {
                completion(.failure(StreamError.firestoreError(error)))
                return
            }
            
            completion(.success(channel))
        })
        
    }
    
    func save(_ messages: [Message], completion: ((Error?) -> Void)? = nil) {
        messages.forEach { message in
            collectionListenerRef?.addDocument(data: message.representation, completion: { error in
                if message.messageType == .chat {
                    completion?(error)
                }
            })
        }
    }
    
    func save(_ messages: [Message], channelId: String) {
        messages.forEach { message in
            REF_CHANNELS.document(channelId).collection("thread").addDocument(data: message.representation)
        }
    }
    
    func removeChatListener() {
        chatListener?.remove()
    }
    
    func removeChatStatusListener() {
        chatStatusListener?.remove()
    }
}
