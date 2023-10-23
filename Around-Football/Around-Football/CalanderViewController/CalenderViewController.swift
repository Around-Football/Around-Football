//
//  CalenderViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/23/23.
//

import UIKit

class CalenderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let calender = Calendar.current
    private let dateFormatter = DateFormatter()
    private lazy var components = calender.dateComponents([.month, .day, .year], from: Date())
    private lazy var calanderDate = calender.date(from: components) ?? Date()
    private var days: [String] = []
    private var selectedIndexPath: IndexPath? //캘린더 선택cell
    private var selectedDateString: String? //캘린더에서 선택한 날짜 String
    private var selectedDate: Date? //캘린더에서 선택한 날짜 Date
    
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
    
    private let timeLabel = UILabel().then {
        $0.text = "Time"
    }
    
    private var timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_kr")
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
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(monthLabel,
                         nextButton,
                         previousButton,
                         dayStackView,
                         dateCollectionView,
                         timeLabel,
                         timePicker)
        
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
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom)
            make.leading.equalToSuperview()
        }
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
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
    
    private func startDayOfWeek() -> Int {
        return calender.component(.weekday, from: calanderDate) - 1
    }

    private func endDate() -> Int {
        return calender.range(of: .day, in: .month, for: calanderDate)?.count ?? Int()
    }

    private func updateTitle() {
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월"
        let date = dateFormatter.string(from: calanderDate)
        monthLabel.text = date
    }
    
    private func stringToDate(dateString: String?) -> Date? { //예시 날짜 문자열 "2023년 10월 24일"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 문자열의 형식과 날짜의 형식을 일치시킵니다.
        
        guard
            let dateString = dateString,
            let date = dateFormatter.date(from: dateString)
        else {
            return nil
        }
        //변환 성공시 Date타입으로 변환
        return date
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
            selectedCell.dateLabel.text != "" //cell에 날짜가 적혀있으면 선택 가능하도록
        else { return }
        
        selectedCell.isSelected = true
        selectedCell.backgroundColor = .gray
        selectedCell.dateLabel.textColor = .white
        
        if let date = Int(selectedCell.dateLabel.text ?? "") { //선택한 Date 저장
            selectedDateString = "\(yearAndMonth) \(date)일"
            selectedDate = stringToDate(dateString: selectedDateString)
            print(selectedDateString as Any)
            print(selectedDate as Any)
        }
        
        // 선택한 셀의 indexPath를 저장
        selectedIndexPath = indexPath
    }
}
