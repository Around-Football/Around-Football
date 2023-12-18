//
//  CalenderViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/23/23.
//

import UIKit

//TODO: - 달력 바꾸기

final class CalenderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let calender = Calendar.current
    private let dateFormatter = DateFormatter()
    private lazy var components = calender.dateComponents([.month, .day, .year], from: Date())
    private lazy var calanderDate = calender.date(from: components) ?? Date()
    private var days: [String] = []
    private var selectedIndexPath: IndexPath? //캘린더 선택cell
    var selectedDateString: String? //캘린더에서 선택한 날짜 String
    var selectedDate: Date? //파베에 올리는 Date타입
    lazy var startTimeString: String = setSelectedTime(input: startTimePicker.date)
    lazy var endTimeString: String = setSelectedTime(input: endTimePicker.date)

    private lazy var previousButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
    }
    
    private lazy var monthLabel = UILabel().then {
        $0.text = "2023년 12월"
    }
    
    private lazy var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<days.count {
            let label = UILabel()
            label.text = days[i]
            label.textAlignment = .center
            
            switch i {
            case _ where i == 0:
                label.textColor = .red
            case _ where i == 6:
                label.textColor = .blue
            default:
                label.textColor = .gray
            }
            
            $0.addArrangedSubview(label)
        }
    }
    
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(DateCell.self, forCellWithReuseIdentifier: DateCell.cellID)
        return cv
    }()
    
    private let startTimeLabel = UILabel().then {
        $0.text = "시작시간"
    }
    
    private let endTimeLabel = UILabel().then {
        $0.text = "종료시간"
    }
    
    private lazy var startTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_kr")
        $0.minuteInterval = 30
        $0.date = Date()
        $0.addTarget(self, action: #selector(startTimePickerSelected), for: .valueChanged)
    }
    
    private lazy var endTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_kr")
        $0.minuteInterval = 30
        $0.date = Date()
        $0.addTarget(self, action: #selector(endTimePickerSelected), for: .valueChanged)
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateCalender()
    }
    
    // MARK: - Selectors
    
    @objc
    private func previousMonth() {
        selectedIndexPath = nil
        minusMonth()
    }
    
    @objc
    private func nextMonth() {
        selectedIndexPath = nil
        plusMonth()
    }
    
    @objc
    private func startTimePickerSelected() {
        startTimeString = setSelectedTime(input: startTimePicker.date)
    }
    
    @objc
    private func endTimePickerSelected() {
        endTimeString = setSelectedTime(input: endTimePicker.date)
    }
    
    // MARK: - Helpers
    
    private func setSelectedTime(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24시간 형식의 시간과 분만 표시
        let result = dateFormatter.string(from: input)
        print(result)
        return result
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(monthLabel,
                         nextButton,
                         previousButton,
                         dayStackView,
                         dateCollectionView,
                         startTimeLabel,
                         startTimePicker,
                         endTimeLabel,
                         endTimePicker)
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalTo(nextButton.snp.leading)
            make.width.height.equalTo(40)
        }
        
        dayStackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(((UIScreen.main.bounds.width - 40) / 7) * 6)
        }
        
        startTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom)
            make.leading.equalToSuperview()
        }
        
        startTimePicker.snp.makeConstraints { make in
            make.centerY.equalTo(startTimeLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(startTimeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        
        endTimePicker.snp.makeConstraints { make in
            make.centerY.equalTo(endTimeLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}

// MARK: - Calender Logic

extension CalenderViewController {
    //이전 달로 이동
    private func minusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: -1), to: calanderDate) ?? Date()
        if let index = selectedIndexPath {
            collectionView(dateCollectionView, didSelectItemAt: index)
        }
        updateCalender()
    }
    
    //다음 달로 이동
    private func plusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: 1), to: calanderDate) ?? Date()
        if let index = selectedIndexPath {
            collectionView(dateCollectionView, didSelectItemAt: index)
        }
        updateCalender()
    }
    
    //이번 달 날짜 시작
    private func startDayOfWeek() -> Int {
        return calender.component(.weekday, from: calanderDate) - 1
    }

    //이번 달 날짜 끝
    private func endDate() -> Int {
        return calender.range(of: .day, in: .month, for: calanderDate)?.count ?? Int()
    }

    //이번 달 Lable표시
    private func updateTitle() {
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        let calenderMonth = dateFormatter.string(from: calanderDate)
        monthLabel.text = calenderMonth
    }
    
//    //선택한 날짜와 시간 selectedDate에 반영
    private func stringToDate(dateString: String?, timePicker: UIDatePicker?) -> Date { //예시 날짜 문자열 "2023년 10월 24일"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" //캘린더에서 선택한 날짜
        
        guard
            let dateString = dateString,
            let date = dateFormatter.date(from: dateString),
            let timePicker = timePicker
        else {
            return Date()
        }
        
        //picker에서 선택한 시간 반영
        let selectedTime = timePicker.date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        guard let resultDate = calendar.date(from: combinedComponents) else { return Date() }
        print("선택된 날짜와 시간은 \(resultDate)입니다")
        return resultDate
    }
    
    private func updateDays() {
        days.removeAll()
        let startDayOfWeek = startDayOfWeek()
        let totalDays = startDayOfWeek + endDate()

        for day in 0..<totalDays {
            if day < startDayOfWeek {
                days.append("")
                continue
            }
            days.append("\(day - startDayOfWeek + 1)")
        }

        dateCollectionView.reloadData()
    }

    private func updateCalender() {
        updateTitle()
        updateDays()
    }
}

extension CalenderViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.cellID, for: indexPath) as! DateCell
        cell.dateLabel.text = days[indexPath.row]
        
        //select된 cell 초기화
        if selectedIndexPath == nil {
            cell.backgroundColor = .white
            cell.isSelected = false
            cell.dateLabel.textColor = .label
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 7
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousSelectedIndexPath = selectedIndexPath,
           let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? DateCell {
            previousSelectedCell.isSelected = false
            previousSelectedCell.backgroundColor = .clear
            previousSelectedCell.dateLabel.textColor = .black
        }
        
        guard
            let selectedCell = collectionView.cellForItem(at: indexPath) as? DateCell,
            let yearAndMonth = monthLabel.text,
            selectedCell.dateLabel.text?.isEmpty == false //cell에 날짜가 적혀있으면 선택 가능하도록
        else { return }
        
        selectedCell.isSelected = true
        selectedCell.backgroundColor = .gray
        selectedCell.dateLabel.textColor = .white
        
        if let date = Int(selectedCell.dateLabel.text ?? "") { //선택한 Date 저장
            selectedDateString = "\(yearAndMonth) \(date)일"
            self.selectedDate = stringToDate(dateString: selectedDateString, timePicker: nil)
            print("날짜 선택됨: \(self.selectedDate)")
            print(selectedDateString as Any)
//            print(selectedStartDate as Any)
        }
        
        // 선택한 셀의 indexPath를 저장
        selectedIndexPath = indexPath
    }
}
