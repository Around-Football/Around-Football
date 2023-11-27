//
//  Firebase.swift
//  Around-Football
//
//  Created by 진태영 on 10/11/23.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import RxAlamofire
import RxSwift

final class FirebaseAPI {
    static let shared = FirebaseAPI()
    
    private init() { }
    
    func createUser(_ result: AuthDataResult) {
        
        let uid = result.user.uid
        
        REF_USER.document(uid)
            .setData(["id" : uid])
    }
    
    func updateUser(_ user: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        REF_USER.document(currentUserID)
            .updateData(
                ["userName" : user.userName,
                 "age" : user.age,
                 "gender" : user.gender,
                 "area" : user.area,
                 "mainUsedFeet" : user.mainUsedFeet,
                 "position" : user.position
                ])
    }
    
    func readUser(completion: @escaping (User?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        REF_USER.document(currentUserID).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                print("readUser성공: \(user)")
                // MARK: - UserService user 업데이
                UserService.shared.user = user
                completion(user)
            case .failure(let error):
                print("Error decoding user: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchFields(completion: @escaping(([Field]) -> Void)) {
        REF_FIELD.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                let errorMessage = error?.localizedDescription ?? "None ERROR"
                print("DEBUG: fetchFields Error - \(errorMessage)")
                return
            }
            
            let documentsData = snapshot.documents.map { $0.data() }
            
            completion(Field.convertToArray(documents: documentsData))
        }
    }
    
    func fetchMockFieldsData(completion: @escaping(([Field]) -> Void)) {
        let fileName: String = "FieldMock"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(
            forResource: fileName,
            withExtension: extensionType
        ) else {
            print("파일 위치 없음")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let decoder = JSONDecoder()
            let fields = try decoder.decode([Field].self, from: data)
            completion(fields)
        } catch {
            print("json load fail")
        }
    }
    
    // MARK: - AuthService
    func updateFCMTokenAndFetchUser(uid: String, fcmToken: String) -> Single<User?> {
        return Single.create { single in
            self.updateFCMToken(uid: uid, fcmToken: fcmToken) { error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                self.fetchUser(uid: uid) { user in
                    single(.success(user))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateFCMToken(uid: String, fcmToken: String, completion: @escaping (Error?) -> Void) {
        let ref = REF_USER.document(uid)
        let data = ["fcmToken": fcmToken]
        updateRefData(ref: ref, data: data, completion: completion)
    }
    
    // TODO: - 창현이와 readUser 함수 맞추기
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        REF_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    // TODO: - ChannelAPI와 통합하기
    func updateRefData(ref: DocumentReference, data: [String: Any], completion: @escaping ((Error?) -> Void)) {
        ref.updateData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            print("DEBUG - Document successfully updated")
            completion(nil)
        }
    }
    
    // MARK: - RxAlamofire
    
    func readRecruitRx() -> Observable<[Recruit]> {
        return Observable.create { observer in
            let collectionRef = Firestore.firestore().collection("Recruit")
            
            collectionRef.getDocuments { snapshot, error in
                if let error {
                    observer.onError(error)
                }
                
                guard let snapshot else { return }
                
                let recruits = snapshot.documents.compactMap { document -> Recruit? in
                    
                    return Recruit(dictionary: document.data())
                }
                
                observer.onNext(recruits)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    //date
    func fetchRecruitFieldDataType(type: String?) -> Observable<[Recruit]> {
        return Observable.create { observer in
            var collectionRef: Query = Firestore.firestore().collection("Recruit")

            // type이 nil이 아닐 때만 whereField를 추가
            if let type = type {
                collectionRef = collectionRef.whereField("type", isEqualTo: type)
            }
            
            collectionRef.getDocuments { snapshot, error in
                if let error {
                    observer.onError(error)
                }
                
                guard let snapshot else { return }
                
                let recruits = snapshot.documents.compactMap { document -> Recruit? in
                    
                    return Recruit(dictionary: document.data())
                }
            
                observer.onNext(recruits)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

// MARK: - Recruit create 함수

extension FirebaseAPI {
    
    func createRecruitFieldData(
        user: User?,
        fieldID: String,
        fieldName: String,
        fieldAddress: String,
        type: String?,
        recruitedPeopleCount: Int,
        title: String?,
        content: String?,
        matchDateString: String?,
        startTime: String?,
        endTime: String?,
        completion: @escaping (Error?) -> Void
    ) {
        guard let user else { return }
        
        let data = ["id": UUID().uuidString,
                    "userID": user.id,
                    "userName": user.userName,
                    "fieldID": fieldID,
                    "fieldName": fieldName,
                    "fieldAddress": fieldAddress,
                    "type": type,
                    "recruitedPeopleCount": recruitedPeopleCount,
                    "title": title,
                    "content": content,
                    "matchDateString": matchDateString,
                    "startTime": startTime,
                    "endTime": endTime
        ] as [String : Any]
        
        REF_RECRUIT
            .document(fieldID)
            .setData(data, completion: completion)
    }
    
    //date
    func fetchRecruitFieldData(
        fieldID: String,
        date: Date,
        completion: @escaping(([Recruit]) -> Void)
    ) {
        REF_RECRUIT
            .whereField("fieldID", isEqualTo: fieldID)
            .whereField("matchDateString", isEqualTo: date)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    let errorMessage = error?.localizedDescription ?? "None ERROR"
                    print("DEBUG: fetchRecruitFieldData Error - \(errorMessage)")
                    return
                }
                
                let documentsData = snapshot.documents.map { $0.data() }
                
            }
    }
    

}

func saveFieldJsonData<T: Encodable>(data:T) {
    let jsonEncoder = JSONEncoder()
    
    do {
        let encodedData = try jsonEncoder.encode(data)
        print(String(data: encodedData, encoding: .utf8)!)
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectoryUrl.appendingPathComponent("FieldMock.json")
        print("DEBUG: FILEURL - \(fileURL.description)")
        
        do {
            try encodedData.write(to: fileURL)
            
            print("Save File")
        }
        catch let error as NSError {
            print(error)
        }
        
        
    } catch {
        print(error)
    }
}
