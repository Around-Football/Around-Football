//
//  InviteViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit
import PhotosUI

import Firebase
import RxCocoa
import RxSwift
import SnapKit
import Then

final class InviteViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: InviteViewModel
    private var searchViewModel: SearchViewModel
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    let contentView = UIView()
    private let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    private let inviteImageView = InviteImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let divider = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private var selectedDate: Date?
    
    private let dateTitleLabel = UILabel().then {
        $0.text = "날짜"
        $0.font = AFFont.titleCard
        $0.sizeToFit()
    }
    
    private let dateFilterButton: UIButton = {
        let button = UIButton().then {
            $0.setTitle("선택하기", for: .normal)
            $0.titleLabel?.font = AFFont.text?.withSize(16)
            $0.setTitleColor(.label, for: .normal)
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                                      leading: 10,
                                                                      bottom: 10,
                                                                      trailing: 10)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 5
            $0.showsMenuAsPrimaryAction = true
        }
        return button
    }()
    
    private lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.minimumDate = Date()
        let titleDateformatter = DateFormatter()
        titleDateformatter.locale = Locale(identifier: "ko_KR")
        titleDateformatter.dateFormat = "M월 d일"
        let matchDateString = titleDateformatter.string(from: Date())
        viewModel.matchDateString.accept(matchDateString)
        let emptyView = UIView()
        emptyView.backgroundColor = .white
        $0.addSubviews(emptyView)
        $0.addSubview(dateFilterButton)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateFilterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.addTarget(self, action: #selector(changeDate), for: .allEvents)
    }
    
    private let timeTitleLabel = UILabel().then {
        $0.text = "시간"
        $0.font = AFFont.titleCard
    }
    
    private lazy var startTimeString: String = setSelectedTime(input: startTimePicker.date)
    private lazy var endTimeString: String = setSelectedTime(input: endTimePicker.date)
    
    private lazy var startTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_kr")
        $0.minuteInterval = 30
        $0.minimumDate = Date(timeIntervalSinceNow: 0)
        $0.addTarget(self, action: #selector(startTimePickerSelected), for: .valueChanged)
    }
    
    private lazy var endTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_kr")
        $0.minuteInterval = 30
        $0.minimumDate = Date(timeInterval: 1800, since: startTimePicker.date)
        $0.addTarget(self, action: #selector(endTimePickerSelected), for: .valueChanged)
    }
    
    private let timePickerSeperator = UILabel().then {
        $0.text = "-"
        $0.font = AFFont.text?.withSize(16)
        $0.sizeToFit()
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "매치 유형"
        $0.font = AFFont.titleCard
    }
    
    private lazy var typeSegmentedControl = UISegmentedControl(
        items: ["풋살", "축구"]
    ).then {
        $0.selectedSegmentIndex = 0 //기본 선택 풋살로
        $0.addTarget(self,
                     action: #selector(typeSegmentedControlValueChanged),
                     for: .valueChanged)
        viewModel.type.accept("풋살")
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = AFFont.titleCard
    }
    
    private lazy var genderSegmentedControl = UISegmentedControl(
        items: ["남성", "여성", "무관"]
    ).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self,
                     action: #selector(genderSegmentedControlValueChanged),
                     for: .valueChanged)
        viewModel.gender.accept("남성")
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "상세내용"
        $0.font = AFFont.titleCard
    }
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        config.imagePadding = 5
        config.imagePlacement = .top
        config.titleAlignment = .center
        return config
    }
    
    var uploadedImages = PublishSubject<[UIImage]>()
    private var images = [UIImage]()
    private lazy var imageButton: UIButton = {
        let button = UIButton(configuration: buttonConfig).then {
            $0.setImage(UIImage(named: AFIcon.imagePlaceholder), for: .normal)
            $0.titleLabel?.font = AFFont.filterRegular
            $0.setTitle("\(images.count)/3", for: .normal)
            $0.setTitleColor(AFColor.grayScale200, for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = AFColor.grayScale100.cgColor
            $0.layer.cornerRadius = 8
        }
        return button
    }()
    
    private let gamePriceLabel = UILabel().then {
        $0.text = "게임비"
        $0.font = AFFont.titleCard
    }
    
    private lazy var gamePriceButton: UIButton = {
        let button = UIButton().then {
            $0.setTitle("선택하기", for: .normal)
            $0.titleLabel?.font = AFFont.text?.withSize(16)
            $0.setTitleColor(.label, for: .normal)
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                                      leading: 10,
                                                                      bottom: 10,
                                                                      trailing: 10)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 8
            $0.showsMenuAsPrimaryAction = true
        }
        
        let prices: [String]  = ["무료", "5,000원", "10,000원",
                                 "15,000원", "20,000원", "30,000원", "기타"]
        
        button.menu = UIMenu(children: prices.map { price in
            UIAction(title: price) { [weak self] _ in
                guard let self else { return }
                button.setTitle(price, for: .normal)
                viewModel.gamePrice.accept(price)
            }
        })
        
        return button
    }()
    
    private lazy var contentTextView = UITextView().then {
        $0.delegate = self
        $0.font = AFFont.text?.withSize(16)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = AFColor.grayScale100.cgColor
        $0.addSubview(contentPlaceHolderLabel)
        contentPlaceHolderLabel.frame = CGRect(x: 5, 
                                               y: 0,
                                               width: 300,
                                               height: 30)
    }
    
    let contentPlaceHolderLabel = UILabel().then {
        $0.text = "추가 내용을 작성해주세요."
        $0.font = AFFont.text?.withSize(16)
        $0.textColor = AFColor.grayScale100
        $0.textAlignment = .left
    }
    
    private lazy var addButton = AFButton(buttonTitle: "등록하기", color: AFColor.primary)
    
    // MARK: - Lifecycles
    
    init(inviteViewModel: InviteViewModel, searchViewModel: SearchViewModel) {
        self.viewModel = inviteViewModel
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
        configureUI()
        keyboardController()
        setAddButton()
        setSearchFieldButton()
        bindImageButtonEvent()
    }
    
    // MARK: - Selectors
    
    @objc
    func typeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.type.accept(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")
    }
    
    @objc
    func genderSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.gender.accept(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")
    }
    
    @objc
    func searchFieldButtonTapped() {
        viewModel.coordinator.presentSearchViewController()
    }
    
    @objc
    func changeDate(_ sender: UIDatePicker) {
        dateFilterButton.isSelected.toggle()
        selectedDate = sender.date
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "YYYY년 M월 d일"
        
        let titleDateformatter = DateFormatter()
        titleDateformatter.locale = Locale(identifier: "ko_KR")
        titleDateformatter.dateFormat = "M월 d일"
        let buttonTitleDate = titleDateformatter.string(from: sender.date)
        let matchDateString = dateformatter.string(from: sender.date)
        dateFilterButton.setTitle(buttonTitleDate, for: .normal)
        viewModel.matchDateString.accept(matchDateString)
    }
    
    @objc
    private func startTimePickerSelected() {
        startTimeString = setSelectedTime(input: startTimePicker.date)
        viewModel.startTime.accept(startTimeString)
    }
    
    @objc
    private func endTimePickerSelected() {
        endTimeString = setSelectedTime(input: endTimePicker.date)
        viewModel.endTime.accept(endTimeString)
    }
    
    @objc
    private func popInviteViewController() {
        viewModel.coordinator.popInviteViewController()
    }
    
    // MARK: - Helpers
    
    private func setSelectedTime(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24시간 형식의 시간과 분만 표시
        let result = dateFormatter.string(from: input)
        print(result)
        return result
    }
    
    private func setSearchFieldButton() {
        placeView.searchFieldButton.addTarget(self,
                                              action: #selector(searchFieldButtonTapped),
                                              for: .touchUpInside)
        
        searchViewModel.dataSubject
            .map {
                $0.name
            }
            .bind(to: placeView.searchFieldButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func bindImageButtonEvent() {
        imageButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, event) in
                var configuaration = PHPickerConfiguration()
                configuaration.selectionLimit = 3
                configuaration.filter = .images
                let picker = PHPickerViewController(configuration: configuaration)
                picker.delegate = self
                owner.viewModel.showPHPickerView(picker: picker)
            }
            .disposed(by: disposeBag)
    }
    
    func areFieldsEmptyObservable() -> Observable<Bool> {
        
        let fieldObservables = [
            viewModel.fieldName.asObservable(),
            viewModel.type.asObservable(),
            viewModel.matchDateString.asObservable(),
            viewModel.startTime.asObservable(),
            viewModel.endTime.asObservable(),
            viewModel.gamePrice.asObservable(),
            viewModel.gender.asObservable(),
            viewModel.content.asObservable()
        ]
        
        return Observable
            .combineLatest(fieldObservables)
            .map { fields in
                return fields.filter { $0 == "" }.count == 0 ? true : false
            }
    }
    
    // TODO: - 업로드 이미지 Rx 바인딩
    private func setImages() {
        lazy var imageViews = [UIImage]()
        uploadedImages.subscribe { images in
            for image in images {
                imageViews.append(image)
            }
        }
        .disposed(by: disposeBag)
        
        imageViews.forEach {
            inviteImageView.image = $0
            contentView.addSubview(inviteImageView)
            inviteImageView.snp.makeConstraints { make in
                make.leading.equalTo(imageButton.snp.trailing).offset(10)
                make.top.bottom.width.height.equalTo(imageButton)
            }
        }
        print("setImage")
    }
    
    private func setAddButton() {
        searchViewModel.dataSubject
            .subscribe(onNext: { [weak self] place in
                guard let self else { return }
                viewModel.fieldName.accept(place.name)
                viewModel.fieldAddress.accept(place.address)
                let region = String(place.address.split(separator: " ").first ?? "")
                viewModel.region.accept(region)
            })
            .disposed(by: disposeBag)
        
        areFieldsEmptyObservable()
            .bind(onNext: { [weak self] bool in
                guard let self else { return }
                if bool == true {
                    addButton.setTitle("작성 완료", for: .normal)
                    addButton.setTitleColor(AFColor.secondary, for: .normal)
                    addButton.isEnabled = true
                } else {
                    addButton.setTitle("모든 항목을 작성해주세요", for: .normal)
                    addButton.setTitleColor(.gray, for: .normal)
                    addButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        addButton.buttonActionHandler = { [weak self] in
            guard let self else { return }
            //현재 값 뷰모델에 전달
            viewModel.peopleCount.accept(peopleView.count)
            viewModel.content.accept(contentTextView.text)
            viewModel.matchDateString.accept(dateFilterButton.currentTitle ?? "")
            viewModel.matchDate.accept(Timestamp(date: datePicker.date))
            viewModel.startTime.accept(startTimeString)
            viewModel.endTime.accept(endTimeString)
            //올리기 함수
            viewModel.createRecruitFieldData()
            viewModel.coordinator.popInviteViewController()
        }
    }
    
    private func keyboardController() {
        //키보드 올리기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        //키보드 내리기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        //화면 탭해서 키보드 내리기
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "용병 구하기"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(placeView,
                                dateTitleLabel,
                                datePicker,
                                peopleView,
                                divider,
                                timeTitleLabel,
                                startTimePicker,
                                timePickerSeperator,
                                endTimePicker,
                                typeLabel,
                                typeSegmentedControl,
                                genderLabel,
                                genderSegmentedControl,
                                gamePriceLabel,
                                gamePriceButton,
                                contentLabel,
                                imageButton,
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
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.centerY.equalTo(datePicker)
            make.height.equalTo(datePicker)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 3/4)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(dateTitleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(34)
            make.width.equalTo(UIScreen.main.bounds.width * 1/4)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(peopleView.snp.bottom).offset(20)
            make.bottom.equalTo(startTimePicker.snp.top).offset(-20)
        }
        
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.centerY.equalTo(startTimePicker)
            make.width.equalTo(UIScreen.main.bounds.width * 1/3)
        }
        
        startTimePicker.snp.makeConstraints { make in
            make.leading.equalTo(timeTitleLabel.snp.trailing)
            make.height.equalTo(datePicker.snp.height)
            make.width.equalTo(datePicker.snp.width)
        }
        
        timePickerSeperator.snp.makeConstraints { make in
            make.leading.equalTo(startTimePicker.snp.trailing).offset(10)
            make.trailing.equalTo(endTimePicker.snp.leading).offset(-10)
            make.bottom.equalTo(timeTitleLabel)
        }
        
        endTimePicker.snp.makeConstraints { make in
            make.top.bottom.equalTo(startTimePicker)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(datePicker.snp.height)
            make.width.equalTo(datePicker.snp.width)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        typeSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(typeLabel)
            make.top.equalTo(startTimePicker.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(datePicker.snp.height)
            make.width.equalTo(datePicker.snp.width)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.top.equalTo(typeLabel.snp.bottom)
        }
        
        genderSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel)
            make.top.equalTo(typeSegmentedControl.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(datePicker.snp.height)
            make.width.equalTo(120)
        }
        
        gamePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        gamePriceButton.snp.makeConstraints { make in
            make.centerY.equalTo(gamePriceLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(datePicker.snp.height)
            make.width.equalTo(datePicker.snp.width)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(gamePriceLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.width.equalTo(80)
            make.height.equalTo(imageButton.snp.width)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(150)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.bottom.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(40)
        }
    }
}

extension InviteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach {
            let itemProvider = $0.itemProvider
            guard
                itemProvider.canLoadObject(ofClass: UIImage.self)
            else {
                return
            }
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard
                    let self = self,
                    let image = image as? UIImage
                else {
                    return
                }
                images.append(image)
            }
        }
        self.uploadedImages.onNext(images)
        picker.dismiss(animated: true)
    }
}
