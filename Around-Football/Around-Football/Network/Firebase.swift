//
//  Firebase.swift
//  Around-Football
//
//  Created by 진태영 on 10/11/23.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

/*
 var id: String
 var userName: String
 var age: Int
 var contact: Int?
 var detailSex: String
 var area: String
 var mainUsedFeet: String
 var position: String
 */

struct FirebaseAPI {
    static let shared = FirebaseAPI()
    
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
    
    func fetchRecruitFieldData(
        fieldID: String,
        date: Date,
        completion: @escaping(([Recruit]) -> Void)
    ) {
        REF_RECRUIT
            .whereField("fieldID", isEqualTo: fieldID)
            .whereField("matchDate", isEqualTo: date)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    let errorMessage = error?.localizedDescription ?? "None ERROR"
                    print("DEBUG: fetchRecruitFieldData Error - \(errorMessage)")
                    return
                }
                
                let documentsData = snapshot.documents.map { $0.data() }
                
            }
    }
    
    // MARK: - AuthService
    func updateFCMTokenAndFetchUser(uid: String, fcmToken: String, completion: @escaping (User?, Error?) -> Void) {
        updateFCMToken(uid: uid, fcmToken: fcmToken) { error in
            if let error = error {
                completion(nil, error)
                return
            }
            fetchUser(uid: uid) { user in
                completion(user, nil)
            }
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
