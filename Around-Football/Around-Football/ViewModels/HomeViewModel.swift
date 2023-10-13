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
    
    var recruitObservable: BehaviorRelay = BehaviorRelay<[Recruit]>(value: [])
    
    init() {
        _ = APIService.fetchfetchRecruitRx()
            .map { data -> [Recruit] in
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.recruits
            }            
            .map { menuItems -> [Recruit] in
                var recruits: [Recruit] = []
                menuItems.forEach { item in
                    let menu = Recruit(id: item.id, userName: item.userName, people: item.people, content: item.content, matchDate: item.matchDate, matchTime: item.matchTime, fieldName: item.fieldName, fieldAddress: item.fieldAddress)
                    recruits.append(menu)
                }
                return recruits
            }
            .take(1)
            .bind(to: recruitObservable)
    }
    

}
