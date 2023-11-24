//
//  Recruit.swift
//  AroundFootball
//
//  Created by 강창현 on 2023/04/13.
//

import Foundation

struct Recruit: Codable, Identifiable {
    var id: String
    var userID: String
    var userName: String //작성자이름
    var fieldID: String //운동장 ID
    var fieldName: String // 운동장 이름
    var fieldAddress: String // 운동장 주소
    var type: String //유형: 풋살, 축구
    var recruitedPeopleCount: Int //모집 인원
    var gamePrice: String // 무료도 있을 수 있으니
    var title: String
    var content: String //작성내용
    var matchDateString: String? //날짜만, String으로 일단 수정
    var startTime: Date? //시작시간
    var endTime: Date? // 종료시간
    
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
        self.type = dictionary["type"] as? String ?? ""
        self.recruitedPeopleCount = dictionary["recruitedPeopleCount"] as? Int ?? Int()
        self.gamePrice = dictionary["gamePrice"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.matchDateString = dictionary["matchDateString"] as? String ?? ""
        self.startTime = dictionary["startTime"] as? Date ?? Date()
        self.endTime = dictionary["endTime"] as? Date ?? Date()
    }
}

