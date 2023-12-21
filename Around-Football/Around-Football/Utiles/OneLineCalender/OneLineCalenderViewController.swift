//
//  OneLineCalenderViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/21/23.
//

import SwiftUI

struct HCalendarView: View {
    @State var selectedDateSet: Set<Date> = []
    private let calendar = Calendar.current
    
    var body: some View {
        
        let startDate = calendar.date(
            from: Calendar.current.dateComponents([.year, .month, .day], from: Date())
        ) ?? Date()
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                let components = (0...14) .map {
                    calendar.date(byAdding: .day, value: $0, to: startDate) ?? Date()
                }
                
                ForEach(components, id: \.self) { date in
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .font(Font(AFFont.titleCard ?? UIFont()))
                            .padding(.bottom, 4)
                        Text(day(from: date))
                            .font(Font(AFFont.filterDay ?? UIFont()))
                    }
                    .foregroundColor(
                        day(from: date) == "토" ? Color(uiColor: AFColor.soccor)
                        : day(from: date) == "일" ? Color(uiColor: AFColor.sunday)
                        : Color(uiColor: AFColor.secondary)
                    )
                    .frame(width: 50, height: 65)
                    .background(selectedDateSet.contains(date)
                                ? Color(uiColor: AFColor.primary)
                                : Color.clear)
                    .cornerRadius(30)
                    .onTapGesture {
                        if selectedDateSet.contains(date) {
                            selectedDateSet.remove(date)
                        } else {
                            selectedDateSet.insert(date)
                        }
                        print("selectedDateSet :\(selectedDateSet)")
                    }
                }
            }
        }
    }
}


extension HCalendarView {
    //요일
    private func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        return dateFormatter.string(from: date)
    }
}
