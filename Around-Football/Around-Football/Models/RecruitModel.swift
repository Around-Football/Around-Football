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
    var matchDate: Timestamp //날짜만, String으로 일단 수정
    var startTime: String //시작시간
    var endTime: String // 종료시간
    var matchDateString: String //쿼리용 String
    var pendingApplicantsUID: [String] //신청한 사람들 uid
    var acceptedApplicantsUID: [String] //승인한 사람들 uid
    var matchDayAndStartTime: String {
        let date = matchDate.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd (E)"

        return "\(dateFormatter.string(from: date)) \(startTime)"
    }
    var currentRecruitedNumber: String {
        return "\(acceptedApplicantsUID.count)/\(recruitedPeopleCount)"
    }
    var representation: [String: Any] {
        let rep = ["id": id,
                   "userID": userID,
                   "userName": userName,
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
        return rep
    }
    
    // create new recruit
    init(userID: String, userName: String, fieldID: String, fieldName: String, fieldAddress: String, region: String, type: String, recruitedPeopleCount: Int, gamePrice: String, title: String, content: String, matchDate: Timestamp, startTime: String, endTime: String, matchDateString: String, pendingApplicantsUID: [String], acceptedApplicantsUID: [String]) {
        self.id = UUID().uuidString
        self.userID = userID
        self.userName = userName
        self.fieldID = fieldID
        self.fieldName = fieldName
        self.fieldAddress = fieldAddress
        self.region = region
        self.type = type
        self.recruitedPeopleCount = recruitedPeopleCount
        self.gamePrice = gamePrice
        self.title = title
        self.content = content
        self.matchDate = matchDate
        self.startTime = startTime
        self.endTime = endTime
        self.matchDateString = matchDateString
        self.pendingApplicantsUID = pendingApplicantsUID
        self.acceptedApplicantsUID = acceptedApplicantsUID
    }
    
    // fetch Data from firebase
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
        self.matchDate = dictionary["matchDate"] as? Timestamp ?? Timestamp()
        self.startTime = dictionary["startTime"] as? String ?? ""
        self.endTime = dictionary["endTime"] as? String ?? ""
        self.pendingApplicantsUID = dictionary["pendingApplicantsUID"] as? [String] ?? []
        self.acceptedApplicantsUID = dictionary["acceptedApplicantsUID"] as? [String] ?? []
    }
}

