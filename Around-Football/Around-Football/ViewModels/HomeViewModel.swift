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
        
    }
    

}
