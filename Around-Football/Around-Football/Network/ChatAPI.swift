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
    var listener: ListenerRegistration?
    var collectionListener: CollectionReference?
    
    func subscribe(id: String) -> Observable<[Message]> {
        
        removeListenr()
        collectionListener = REF_CHANNELS.document(id).collection("thread")
        
        return Observable.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let self = self else { return Disposables.create() }
            
            self.listener = collectionListener?
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
    
    func save(_ messages: [Message], completion: ((Error?) -> Void)? = nil) {
        messages.forEach { message in
            collectionListener?.addDocument(data: message.representation, completion: { error in
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
    
    func removeListenr() {
        listener?.remove()
    }
}
