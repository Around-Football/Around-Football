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
    
    // MARK: - Properties

    //캘린더
    private let calender = Calendar.current
    private let dateFormatter = DateFormatter()
    private lazy var components = calender.dateComponents([.month, .day, .year], from: Date())
    private lazy var calanderDate = calender.date(from: components) ?? Date()
    private var days: [String] = []
    private var selectedIndexPath: IndexPath? //캘린더 선택cell
    private var selectedDate: String? //캘린더에서 선택한 날짜
    //UI
    private let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
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
    
    private lazy var contentTextView = UITextView().then {
        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray.cgColor
//        $0.placeholder = "내용을 입력해주세요"
        $0.addSubview(placeHolderLabel)
        placeHolderLabel.frame = CGRect(x: 5, y: 0, width: 300, height: 30)
    }
    
    private let placeHolderLabel = UILabel().then {
        $0.text = "내용을 입력해주세요"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    
    private let addButton = CustomButton(frame: .zero, buttonTitle: "등록하기")
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateCalender()
        keyboardController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    
    @objc private func previousMonth() {
        minusMonth()
    }
    
    @objc private func nextMonth() {
        plusMonth()
    }
    
    // MARK: - Helpers
    
    private func keyboardController() {
        //키보드 올리기, 내리기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        //화면 탭해서 키보드 내리기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "용병 구하기"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
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
                         contentTextView,
                         addButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 2/3)
            make.height.equalTo(50)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
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
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(150)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }
    
    private func minusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: -1), to: calanderDate) ?? Date()
        if let index = selectedIndexPath {
            collectionView(dateCollectionView, didSelectItemAt: index)
        }
        
        updateCalender()
    }
    
    private func plusMonth() {
        calanderDate = calender.date(byAdding: DateComponents(month: 1), to: calanderDate) ?? Date()
        if let index = selectedIndexPath {
            collectionView(dateCollectionView, didSelectItemAt: index)
        }
        updateCalender()
    }
}

// MARK: - 키보드 관련 함수

extension InviteViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TextViewDelegate

extension InviteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
}

// MARK: - 달력 구현

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
            previousSelectedCell.dateLabel.textColor = .black
        }
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? DateCell,
              let yearAndMonth = monthLabel.text
        else { return }
        selectedCell.isSelected = true
        selectedCell.backgroundColor = .blue
        selectedCell.dateLabel.textColor = .white
        if let date = Int(selectedCell.dateLabel.text ?? "") {
            selectedDate = "\(yearAndMonth) \(date)일"
        }
        
        // 선택한 셀의 indexPath를 저장
        selectedIndexPath = indexPath
        print(selectedDate)
    }
}
