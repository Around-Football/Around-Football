//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import Foundation

import RxSwift
import RxRelay

class HomeViewModel {
    
    /*
     Rx
     Observable:
     1. Observable - 데이터 주입 후 변경 안됨.
     2. Subject - 데이터 주입 후 변경 가능.
        - 데이터 로드 시점 == 사용시점
     3. Relay
        
     */
    
    var recruitObservable: BehaviorRelay = BehaviorRelay<[Recruit_Rx]>(value: [])
    
    init() {
        _ = APIService.fetchfetchRecruitRx()
            .map { data -> [Recruit_Rx] in
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.recruits
            }            
            .map { menuItems -> [Recruit_Rx] in
                var recruits: [Recruit_Rx] = []
                menuItems.forEach { item in
                    let menu = Recruit_Rx(id: item.id, userName: item.userName, people: item.people, content: item.content, matchDate: item.matchDate, matchTime: item.matchTime, fieldName: item.fieldName, fieldAddress: item.fieldAddress)
                    recruits.append(menu)
                }
                return recruits
            }
            .take(1)
            .bind(to: recruitObservable)
    }
    

}
