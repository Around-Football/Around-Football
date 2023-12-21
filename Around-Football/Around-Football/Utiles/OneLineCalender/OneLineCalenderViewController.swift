//
//  OneLineCalenderViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/21/23.
//

import SwiftUI

struct HCalendarView: View {
    @State private var selectedDate = Date()
    @State var selectedDateArr = [Date]()
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            dayView
        }
    }
    
    // MARK: - 일자 표시 뷰
    @ViewBuilder
    private var dayView: some View {
        let startDate = calendar.date(from: Calendar.current.dateComponents([.day], from: Date()))!
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                let components = (0...14)
                    .map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }
                
                ForEach(components, id: \.self) { date in
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .font(Font(AFFont.titleCard ?? UIFont()))
                        Text(day(from: date))
                            .font(Font(AFFont.filterDay ?? UIFont()))
                            .foregroundColor(Color(uiColor: AFColor.secondary))
                    }
                    .frame(width: 50, height: 65)
                    .background(calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color(uiColor: AFColor.primary) : Color.clear)
                    .cornerRadius(25)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
    }
}

// MARK: - 로직
private extension HCalendarView {
    
    /// 요일 추출
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        return dateFormatter.string(from: date)
    }
}
