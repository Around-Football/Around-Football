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
    
    func updateUser(_ user: User, completion: ((Error?) -> Void)? = nil) {
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
        print("유저 업데이트 됨")
        UserService.shared.currentUser_Rx.onNext(user) //유저 업데이트하고 업데이트한 유저정보 보내줌
        UserService.shared.checkUserInfoExist.onNext(true)
    }
    
    //회원 탈퇴
    func deleteUser(_ userID: String) {
        let ref = REF_USER.document(userID)
        ref.delete { error in
            if error != nil {
                print("유저 탈퇴 에러 발생")
            }
            
            print("\(userID)유저 삭제됨.")
            UserService.shared.currentUser_Rx.onNext(nil)
        }
    }
    
    //uid로 유저 불러오기
    func fetchUser(uid: String, completion: @escaping (User?) -> Void) {
        REF_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return completion(nil) }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUser(uid: String) async throws -> User? {
        guard let data = try await REF_USER.document(uid).getDocument().data() else { return nil }
        
        let user = User(dictionary: data)
        return user
    }
    
    func fetchUsersRx(uids: [String]) -> Observable<[User]> {
        return Observable.create { [ weak self ] observe in
            guard let self = self else { return Disposables.create() }
            Task {
                do {
                    var users: [User] = []
                    for uid in uids {
                        guard let user = try await self.fetchUser(uid: uid) else { continue }
                        users.append(user)
                    }
                    observe.onNext(users)
                    observe.onCompleted()
                } catch let error as NSError {
                    print("DEBUG - Error: \(error.localizedDescription)")
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchFields(completion: @escaping ([Field]) -> Void) async throws {
        Task {
            var fields = [Field]()
            let documentsData = try await REF_FIELD.getDocuments().documents.map { $0.data() }
            for data in documentsData {
                let field = Field(dictionary: data)
                try await fetchAvailableRecruitFieldData(fieldID: field.id) { recruits in
                    guard !recruits.isEmpty else { return }
                    fields.append(field)
                }
            }
            completion(fields)
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
    
    func fetchRecruit(recruitID: String) async throws -> Recruit? {
        guard let data = try await REF_RECRUIT.document(recruitID).getDocument().data() else { return nil }
        
        let recruit = Recruit(dictionary: data)
        
        return recruit
    }
    
    func deleteRecruit(recruitID: String, completion: @escaping((Error?) -> Void)) {
        REF_RECRUIT.document(recruitID).delete(completion: completion)
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
                    .whereField("region", isEqualTo: region)
            }
            
            if let type = input.type {
                collectionRef = collectionRef
                    .whereField("type", isEqualTo: type)
            }
            
            if let gender = input.gender {
                collectionRef = collectionRef
                    .whereField("gender", isEqualTo: gender)
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
            guard user.bookmarkedRecruit.count != 0
            else {
                observer.onNext([])
                return Disposables.create()
            }
            
            REF_RECRUIT
                .whereField("id", in: user.bookmarkedRecruit as [Any])
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
    
    func loadWrittenPostRx(userID: String?) -> Observable<[Recruit]> {
        return Observable.create { observer in
            //유저불러옴
            guard let user = try? UserService.shared.currentUser_Rx.value() else {
                return Disposables.create()
            }
            
            REF_RECRUIT
                .whereField("userID", isEqualTo: user.id)
                .getDocuments { snapshot, error in
                    if error != nil {
                        print("loadWrittenPostRx 추가 오류: \(String(describing: error?.localizedDescription))")
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    let writtenPost = documents.map {
                        Recruit(dictionary: $0.data())
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
            guard let user = try? UserService.shared.currentUser_Rx.value() else {
                return Disposables.create()
            }
            
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
    func acceptApplicants(recruitID: String, userID: String, completion: @escaping((Error?) -> Void)) {
        REF_RECRUIT.document(recruitID).getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let self = self,
                  var data = snapshot?.data(),
                  var acceptedApplicants = data["acceptedApplicantsUID"] as? [String]
            else { return }
            //승인한 유저 acceptedApplicantsUID 배열에 추가
            acceptedApplicants.append(userID)
            data.updateValue(acceptedApplicants, forKey: "acceptedApplicantsUID")
            
            let ref = REF_RECRUIT.document(recruitID)
            self.updateRefData(ref: ref, data: data, completion: completion)
        }
    }
    
    func cancelApplicants(recruitID: String, userID: String, completion: @escaping((Error?) -> Void)) {
        REF_RECRUIT.document(recruitID).getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard var data = snapshot?.data(),
                  var acceptedApplicants = data["acceptedApplicantsUID"] as? [String] else { return }
            acceptedApplicants.removeAll(where: { $0 == userID })
            data.updateValue(acceptedApplicants, forKey: "acceptedApplicantsUID")
            let ref = REF_RECRUIT.document(recruitID)
            self?.updateRefData(ref: ref, data: data, completion: completion)
        }
    }
}

// MARK: - Recruit 함수

extension FirebaseAPI {
    
    func createRecruitFieldData(
        recruit: Recruit,
        completion: @escaping (Error?) -> Void
    ) {
        REF_RECRUIT
            .document(recruit.id)
            .setData(recruit.representation, completion: completion)
    }
    
    func fetchRecruitFieldData(
        fieldID: String,
        completion: @escaping(([Recruit]) -> Void)
    ) {
        let currentDate = Date()
        REF_RECRUIT
            .whereField("fieldID", isEqualTo: fieldID)
            .whereField("matchDate", isGreaterThan: currentDate)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    let errorMessage = error?.localizedDescription ?? "None ERROR"
                    print("DEBUG: fetchRecruitFieldData Error - \(errorMessage)")
                    return
                }
                let recruits = snapshot.documents.compactMap { document -> Recruit? in
                    Recruit(dictionary: document.data())
                }
                completion(recruits)
            }
    }
    
    func updateRecruitData(recruit: Recruit, completion: @escaping (Error?) -> Void) {
        let ref = REF_RECRUIT.document(recruit.id)
        let data = recruit.representation
        updateRefData(ref: ref, data: data, completion: completion)
    }
}

// MARK: - Field

extension FirebaseAPI {
    func fetchAvailableRecruitFieldData(
        fieldID: String,
        completion: @escaping(([Recruit]) -> Void)
    ) async throws {
        let currentDate = Date()
        let snapshot = try await REF_RECRUIT
            .whereField("fieldID", isEqualTo: fieldID)
            .whereField("matchDate", isGreaterThan: currentDate)
            .getDocuments()
        
        let recruits = snapshot.documents.compactMap { document -> Recruit? in
            Recruit(dictionary: document.data())
        }
        completion(recruits)
    }
    
    func createFieldData(
        field: Field,
        recruit: Recruit,
        completion: @escaping (Error?) -> Void
    ) {
        REF_FIELD
            .whereField("id", isEqualTo: field.id)
            .getDocuments { snapshot, error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                guard 
                    let recruitListDocument = snapshot?.documents.first
                else {
                    REF_FIELD.document(field.id).setData(
                        field.representation,
                        completion: completion
                    )
                    return
                }
                
                guard 
                    var updatedRecruitList = recruitListDocument.data()["recruitList"] as? [String]
                else
                {
                    return
                }
                updatedRecruitList.append(recruit.id)
                recruitListDocument.reference.updateData(
                    ["recruitList": updatedRecruitList],
                    completion: completion
                )
            }
    }
    
    func fetchFieldData(fieldID: String) {
        REF_FIELD
            .whereField(fieldID, isEqualTo: fieldID)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    let errorMessage = error?.localizedDescription ?? "None ERROR"
                    print("DEBUG: fetchRecruitFieldData Error - \(errorMessage)")
                    return
                }
                _ = snapshot.documents.map { $0.data() }
            }
    }
}
