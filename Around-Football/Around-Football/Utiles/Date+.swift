//
//  Date+.swift
//  Around-Football
//
//  Created by 강창현 on 2/26/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M/d (EEE)"
        let formattedDateString = dateFormatter.string(from: self)
        return formattedDateString
    }
}
