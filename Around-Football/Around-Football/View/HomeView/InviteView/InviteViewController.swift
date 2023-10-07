//
//  InviteViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

final class InviteViewController: UIViewController {
    private let calender = Calendar.current
    private let dateFormatter = DateFormatter()
    private lazy var components = calender.dateComponents([.month, .day, .year], from: Date())
    private lazy var calanderDate = calender.date(from: components) ?? Date()
    private var days: [String] = []
    
    private let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    
    var selectedIndexPath: IndexPath?
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let contentView = UIView()
    
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
    
    private let contentLabel = UILabel().then {
        $0.text = "내용"
    }
    
    private let contentTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "내용을 입력해주세요"
    }
    
    private let addButton = CustomButton(frame: .zero, buttonTitle: "등록하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateCalender()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "용병 구하기"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubviews(placeView,
                         peopleView,
                         monthLabel,
                         nextButton,
                         previousButton,
                         dayStackView,
                         dateCollectionView,
                         timeLabel,
                         timePicker,
                         contentLabel,
                         contentTextField,
                         addButton)
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 2/3)
            make.height.equalTo(50)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(UIScreen.main.bounds.width * 1/3)
            make.height.equalTo(50)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalTo(nextButton.snp.leading).offset(-20)
            make.width.height.equalTo(40)
        }
        
        dayStackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(((UIScreen.main.bounds.width - 40) / 7) * 6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
        }
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(150)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func minusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: -1), to: calanderDate) ?? Date()
        updateCalender()
    }
    
    private func plusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: 1), to: calanderDate) ?? Date()
        updateCalender()
    }
    
    @objc private func previousMonth() {
        minusMonth()
    }
    
    @objc private func nextMonth() {
        plusMonth()
    }
}

extension InviteViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            print("keyboardHeight: \(keyboardHeight)")
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.scrollIndicatorInsets.bottom = keyboardHeight
            
            // 스크롤뷰를 활성화합니다.
            scrollView.isScrollEnabled = true
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        print("contentInset: \(scrollView.contentInset)")
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        print("contentInset: \(scrollView.contentInset)")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension InviteViewController {
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

extension InviteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.cellID, for: indexPath) as! DateCell
        cell.dateLabel.text = days[indexPath.row]
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
            previousSelectedCell.dateLabel.textColor = .label
        }
        
        selectedIndexPath = indexPath
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? DateCell {
            selectedCell.isSelected = true
            selectedCell.backgroundColor = .blue
            selectedCell.dateLabel.textColor = .white
        }
    }
}
