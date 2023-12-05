//
//  Recruit.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import Firebase
import FirebaseFirestore

struct Recruit: Codable, Identifiable {
    var id: String
    var userID: String
    var userName: String //작성자이름
    var fieldID: String //운동장 ID
    var fieldName: String // 운동장 이름
    var fieldAddress: String // 운동장 주소
    var region: String
    var type: String //유형: 풋살, 축구
    var recruitedPeopleCount: Int //모집 인원
    var gamePrice: String // 무료도 있을 수 있으니
    var title: String
    var content: String //작성내용
    var matchDateString: String? //날짜만, String으로 일단 수정
    var startTime: String? //시작시간
    var endTime: String? // 종료시간
    var acceptedApplicants: [User] = []
    
    //TODO: - 서브 컬렉션으로 신청한사람 Uid, 수락했는지 여부 추가하기
    
    // MARK: - 신청자 UID 보관할 collection 관련 함수
    
    //신청자 서브컬렉션 접근
    var applicantsCollectionRef: CollectionReference {
        return REF_RECRUIT.document(fieldID).collection("Applicants")
    }
    
    //서브콜렉션에 신청자 추가
    func apply(user: User?) {
        applicantsCollectionRef.document(user?.id ?? "").setData(["id" : user?.id,
                                                                  "userName" : user?.userName,
                                                                  "age" : user?.age,
                                                                  "gender" : user?.gender,
                                                                  "area" : user?.area,
                                                                  "mainUsedFeet" : user?.mainUsedFeet,
                                                                  "position" : user?.position
                                                                 ])
    }
    
    //    //수락하기 하면 배열에 Recruit의 추가
    //    func acceptedApplicants(withUserID userID: String, toNewDocument newDocumentID: String) {
    //        let moveToDoc = REF_RECRUIT.document(fieldID)
    //
    //        moveToDoc.getDocument { snapshot, error in
    //            if let error {
    //                print("승인된 유저 UID 이동 오류")
    //            }
    //
    //            if var data = snapshot?.data(),
    //               var acceptedApplicants = data["acceptedApplicants"] as? [String] {
    //                // 이미 존재하는 배열에 새로운 유저 아이디 추가
    //                acceptedApplicants.append(userID)
    //                // 업데이트된 배열을 다시 Firestore에 저장
    //                data["acceptedApplicants"] = acceptedApplicants
    //                moveToDoc.setData(data)
    //            } else {
    //                // 배열이 없으면 새로 생성하고 유저 아이디 추가
    //                let newAcceptedApplicants = [userID]
    //                moveToDoc.setData(["acceptedApplicants": newAcceptedApplicants])
    //            }
    //        }
    //    }
    //
    //    //거절하기 하면 uid 지움
    //    func deleteApplicant(withUserID userID: String) {
    //        applicantsCollectionRef.document(userID).delete { error in
    //            if let error = error {
    //                print("Error deleting document: \(error)")
    //            } else {
    //                print("Document successfully deleted!")
    //            }
    //        }
    //    }
    
    //    //서브콜렉션에서 신청자 제거
    //    func removeApplicant(withUserID userID: String) {
    //        let query = applicantsCollectionRef.whereField("userID", isEqualTo: userID)
    //        query.getDocuments { (snapshot, error) in
    //            if let error = error {
    //                print("Error removing applicant: \(error)")
    //            } else {
    //                guard let documents = snapshot?.documents else { return }
    //                for document in documents {
    //                    document.reference.delete()
    //                }
    //            }
    //        }
    //    }
    
    //TODO: -신청한 용병 데이터 어떻게 보여줄건지
    
    static func convertToArray(documents: [[String: Any]]) -> [Recruit] {
        var array: [Recruit] = []
        for document in documents {
            let recruit = Recruit(dictionary: document)
            array.append(recruit)
        }
        
        return array
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.userID = dictionary["userID"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.fieldID = dictionary["fieldID"] as? String ?? ""
        self.fieldName = dictionary["fieldName"] as? String ?? ""
        self.fieldAddress = dictionary["fieldAddress"] as? String ?? ""
        self.region = dictionary["region"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.recruitedPeopleCount = dictionary["recruitedPeopleCount"] as? Int ?? Int()
        self.gamePrice = dictionary["gamePrice"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.matchDateString = dictionary["matchDateString"] as? String ?? ""
        self.startTime = dictionary["startTime"] as? String ?? ""
        self.endTime = dictionary["endTime"] as? String ?? ""
        self.acceptedApplicants = dictionary["acceptedApplicants"] as? [User] ?? []
    }
}

