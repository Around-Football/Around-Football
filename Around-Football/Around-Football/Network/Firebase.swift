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
    
    func updateUser(_ user: User, completion: ((Error?) -> Void)? = nil) {
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let ref = REF_USER.document(user.id)
        updateRefData(ref: ref, data: user.representation) { error in
            if let error = error {
                print("DEBUG - Error", #function, error.localizedDescription)
                completion?(error)
                return
            }
            UserService.shared.currentUser_Rx.onNext(user)
            completion?(nil)
        }
//        REF_USER.document(currentUserID)
//            .updateData(
//                ["userName" : user.userName,
//                 "age" : user.age,
//                 "gender" : user.gender,
//                 "area" : user.area,
//                 "mainUsedFeet" : user.mainUsedFeet,
//                 "position" : user.position,
//                 "bookmarkedRecruit" : user.bookmarkedRecruit]
//            )
        
        UserService.shared.currentUser_Rx.onNext(user) //유저 업데이트하고 업데이트한 유저정보 보내줌
    }
    
    //uid로 유저 불러오기
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        REF_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUser(uid: String) async throws -> User {
        let result = try await REF_USER.document(uid).getDocument()
        
        let user = User(dictionary: result.data()!)
        return user
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
    
    func fetchRecruit(recruitID: String, completion: @escaping(Recruit?, Error?) -> Void) {
        REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(nil, nil)
                return
            }
            let recruit = Recruit(dictionary: data)
            completion(recruit, nil)
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
    
    //HomeList
    func readRecruitRx(input: RecruitFilter
    ) -> Observable<[Recruit]> {
        return Observable.create { observer in
            var collectionRef: Query = REF_RECRUIT
            
            if let region = input.region {
                collectionRef = collectionRef
                    .whereField("region", isEqualTo: input.region)
            }
            
            if let type = input.type {
                collectionRef = collectionRef
                    .whereField("type", isEqualTo: input.type)
            }
            
            if let gender = input.gender {
                collectionRef = collectionRef
                    .whereField("gender", isEqualTo: input.gender)
            }
            
            collectionRef.getDocuments { snapshot, error in
                if let error {
                    observer.onError(error)
                }
                
                guard let snapshot else { return }
                
                let recruits = snapshot.documents.compactMap { document -> Recruit? in
                    Recruit(dictionary: document.data())
                }
                
                observer.onNext(recruits)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}

// MARK: - Applicants 관련 함수
extension FirebaseAPI {
    //유저가 등록한 북마크만 찾아서 보냄
    func loadBookmarkPostRx(userID: String?) -> Observable<[Recruit]> {
        return Observable.create { observer in
            //유저불러옴
            guard let user = try? UserService.shared.currentUser_Rx.value() else { return Disposables.create() }
            
            let userBookmarkList = user.bookmarkedRecruit
            
            REF_RECRUIT
                .whereField("id", in: userBookmarkList as [Any])
                .getDocuments { snapshot, error in
                    if error != nil {
                        print("loadBookmarkPostRx 추가 오류: \(String(describing: error?.localizedDescription))")
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    let bookmarkPost = documents.compactMap { document -> Recruit? in
                        let recruitData = document.data()
                        return Recruit(dictionary: recruitData)
                    }
                    
                    observer.onNext(bookmarkPost)
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    //유저가 신청하기 누르면 pendingApplicationsUID 추가
    func loadWrittenPostRx(userID: String?) -> Observable<[Recruit]> {
        return Observable.create { observer in
            //유저불러옴
            guard let user = try? UserService.shared.currentUser_Rx.value() else { return Disposables.create() }
            
            REF_RECRUIT
                .whereField("userID", isEqualTo: user.id)
                .getDocuments { snapshot, error in
                    if error != nil {
                        print("loadWrittenPostRx 추가 오류: \(String(describing: error?.localizedDescription))")
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    let writtenPost = documents.compactMap { document -> Recruit? in
                        let recruitData = document.data()
                        return Recruit(dictionary: recruitData)
                    }
                    
                    observer.onNext(writtenPost)
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    func loadApplicationPostRx(userID: String?) -> Observable<[Recruit]> {
        return Observable.create { observer in
            //유저불러옴
            guard let user = try? UserService.shared.currentUser_Rx.value() else { return Disposables.create() }
            
            REF_RECRUIT
                .whereField("pendingApplicantsUID", arrayContains: user.id)
                .getDocuments { snapshot, error in
                    if error != nil {
                        print("loadApplicationPostRx 추가 오류: \(String(describing: error?.localizedDescription))")
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    let applicationPost = documents.compactMap { document -> Recruit? in
                        let recruitData = document.data()
                        return Recruit(dictionary: recruitData)
                    }
                    
                    observer.onNext(applicationPost)
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    //유저가 신청하기 누르면 pendingApplicationsUID 추가
    func loadPendingApplicantRx(recruitID: String) -> Observable<[String]> {
        return Observable.create { observer in
            REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
                if error != nil {
                    print("ppendingApplicantUID 추가 오류")
                }
                
                guard
                    let data = snapshot?.data(),
                    let pendingApplicants = data["pendingApplicantsUID"] as? [String]
                else { return }
                
                observer.onNext(pendingApplicants)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func loadAcceptedApplicantRx(recruitID: String, uid: String) -> Observable<[String]> {
        return Observable.create { observer in
            REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
                if error != nil {
                    print("pendingApplicationsUID 추가 오류")
                }
                
                guard
                    var data = snapshot?.data(),
                    var pendingApplicants = data["pendingApplicantsUID"] as? [String],
                    var acceptedApplicants = data["acceptedApplicantsUID"] as? [String]
                else { return }
                //승인한 유저 acceptedApplicantsUID 배열에 추가
                acceptedApplicants.append(uid)
                data.updateValue(acceptedApplicants, forKey: "acceptedApplicantsUID")
                
                //승인한 유저 pendingApplicantsUID 배열에서 제거
                pendingApplicants.removeAll { str in
                    str == uid ? true : false
                }
                data.updateValue(pendingApplicants, forKey: "pendingApplicantsUID")
                
                REF_RECRUIT.document(recruitID).updateData(data)
                
                observer.onNext(pendingApplicants)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func loadRejectedApplicantRx(recruitID: String, uid: String) -> Observable<[String]> {
        return Observable.create { observer in
            REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
                if error != nil {
                    print("deleteApplicantError \(String(describing: error?.localizedDescription))")
                }
                
                guard var data = snapshot?.data(),
                      var pendingApplicants = data["pendingApplicantsUID"] as? [String] else { return }
                
                pendingApplicants.removeAll(where: { userID in
                    userID == uid ? true : false
                })
                data.updateValue(pendingApplicants, forKey: "pendingApplicantsUID")
                
                REF_RECRUIT.document(recruitID).updateData(data)
                
                observer.onNext(pendingApplicants)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    //유저 추가
    func appendPendingApplicant(recruitID: String, userID: String, completion: @escaping((Error?) -> Void )) {
        REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard
                var data = snapshot?.data(),
                var pendingApplicants = data["pendingApplicantsUID"] as? [String?]
            else {
                completion(NSError(domain: "Parsing Error", code: -1))
                return
            }
            
            pendingApplicants.append(userID)
            data.updateValue(pendingApplicants, forKey: "pendingApplicantsUID")
            let ref = REF_RECRUIT.document(recruitID)
            self.updateRefData(ref: ref, data: data, completion: completion)
        }
    }
    
    //승인하면 배열 요소 이동
    func acceptApplicants(recruitID: String, userID: String?) {
        REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
            if error != nil {
                print("pendingApplicationsUID 추가 오류")
            }
            
            guard
                var data = snapshot?.data(),
                var pendingApplicants = data["pendingApplicantsUID"] as? [String?],
                var acceptedApplicants = data["acceptedApplicantsUID"] as? [String?]
            else { return }
            //승인한 유저 acceptedApplicantsUID 배열에 추가
            acceptedApplicants.append(userID)
            data.updateValue(acceptedApplicants, forKey: "acceptedApplicantsUID")
            
            //승인한 유저 pendingApplicantsUID 배열에서 제거
            pendingApplicants.removeAll { str in
                str == userID ? true : false
            }
            data.updateValue(pendingApplicants, forKey: "pendingApplicantsUID")
            
            REF_RECRUIT.document(recruitID).updateData(data)
        }
    }
    
    //거절하기 하면 uid 지움
    func deleteApplicant(recruitID: String, userID: String?) {
        REF_RECRUIT.document(recruitID).getDocument { snapshot, error in
            if error != nil {
                print("deleteApplicantError \(String(describing: error?.localizedDescription))")
            }
            
            guard var data = snapshot?.data(),
                  var pendingApplicants = data["pendingApplicantsUID"] as? [String?] else { return }
            
            pendingApplicants.removeAll(where: { uid in
                uid == userID ? true : false
            })
            data.updateValue(pendingApplicants, forKey: "pendingApplicantsUID")
            
            REF_RECRUIT.document(recruitID).updateData(data)
        }
    }
}

// MARK: - Recruit create 함수

extension FirebaseAPI {
    
    func createRecruitFieldData(
        user: User?,
        fieldID: String,
        fieldName: String,
        fieldAddress: String,
        region: String,
        type: String?,
        recruitedPeopleCount: Int,
        gamePrice: String,
        title: String?,
        content: String?,
        matchDateString: String?,
        matchDate: Timestamp?,
        startTime: String?,
        endTime: String?,
        pendingApplicantsUID: [String?],
        acceptedApplicantsUID: [String?],
        completion: @escaping (Error?) -> Void
    ) {
        guard let user else { return }
        let id = UUID().uuidString
        let data = ["id": id,
                    "userID": user.id,
                    "userName": user.userName,
                    "fieldID": fieldID,
                    "fieldName": fieldName,
                    "fieldAddress": fieldAddress,
                    "region": region,
                    "type": type,
                    "recruitedPeopleCount": recruitedPeopleCount,
                    "gamePrice": gamePrice,
                    "title": title,
                    "content": content,
                    "matchDateString": matchDateString,
                    "matchDate": matchDate,
                    "startTime": startTime,
                    "endTime": endTime,
                    "pendingApplicantsUID": pendingApplicantsUID,
                    "acceptedApplicantsUID": acceptedApplicantsUID] as [String : Any]
        
        REF_RECRUIT
            .document(id)
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

//func saveFieldJsonData<T: Encodable>(data:T) {
//    let jsonEncoder = JSONEncoder()
//
//    do {
//        let encodedData = try jsonEncoder.encode(data)
//        print(String(data: encodedData, encoding: .utf8)!)
//
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileURL = documentDirectoryUrl.appendingPathComponent("FieldMock.json")
//        print("DEBUG: FILEURL - \(fileURL.description)")
//
//        do {
//            try encodedData.write(to: fileURL)
//
//            print("Save File")
//        }
//        catch let error as NSError {
//            print(error)
//        }
//
//
//    } catch {
//        print(error)
//    }
//}
