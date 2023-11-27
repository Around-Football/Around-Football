//
//  InviteViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class InviteViewController: UIViewController {
    
    // MARK: - Properties

    var inviteViewModel: InviteViewModel
    var searchViewModel: SearchViewModel
    let disposeBag = DisposeBag()
    let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    private let calenderViewController = CalenderViewController()
    let contentView = UIView()
    
    private var id = UserService.shared.user?.id
    private var userName = UserService.shared.user?.userName
    private var fieldID = UUID().uuidString
    private lazy var fieldName: String = ""
    private lazy var fieldAddress: String = ""
    private var type: String?
    private lazy var recruitedPeopleCount = peopleView.count
    private lazy var contentTitle = titleTextField.text
    private lazy var content = contentTextView.text
    private lazy var matchDateString = calenderViewController.selectedDateString
    private lazy var startTime = calenderViewController.startTimeString
    private lazy var endTime = calenderViewController.endTimeString
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "유형"
    }
    
    private lazy var typeSegmentedControl = UISegmentedControl(
        items: ["풋살", "축구"]
    ).then {
        $0.selectedSegmentIndex = 0 //기본 선택 풋살로
        $0.addTarget(self,
                     action: #selector(segmentedControlValueChanged),
                     for: .valueChanged)
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "내용"
    }
    
    lazy var titleTextField = UITextField().then {
        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.addSubview(titlePlaceHolderLabel)
        titlePlaceHolderLabel.frame = CGRect(x: 5, y: 0, width: 300, height: 30)
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.addSubview(contentPlaceHolderLabel)
        contentPlaceHolderLabel.frame = CGRect(x: 5, y: 0, width: 300, height: 30)
    }
    
    let titlePlaceHolderLabel = UILabel().then {
        $0.text = "제목을 입력해주세요"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    let contentPlaceHolderLabel = UILabel().then {
        $0.text = "내용을 입력해주세요"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    private lazy var addButton = AFButton(frame: .zero, buttonTitle: "등록하기")
    
    // MARK: - Lifecycles
    
    init(inviteViewModel: InviteViewModel, searchViewModel: SearchViewModel) {
        self.inviteViewModel = inviteViewModel
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        keyboardController()
        setAddButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        type = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    // MARK: - Helpers
    
    private func setAddButton() {
        
        searchViewModel.dataSubject
            .subscribe(onNext: { [weak self] place in
                self?.fieldName = place.name
                self?.fieldAddress = place.address
            })
            .disposed(by: disposeBag)
        
        
        addButton.buttonActionHandler = { [weak self] in
            guard let self else { return }
            inviteViewModel.createRecruitFieldData(user: UserService.shared.user ?? User(dictionary: [:]),
                                                   fieldID: fieldID,
                                                   fieldName: fieldName,
                                                   fieldAddress: fieldAddress,
                                                   type: type,
                                                   recruitedPeopleCount: recruitedPeopleCount,
                                                   title: contentTitle,
                                                   content: content,
                                                   matchDateString: matchDateString,
                                                   startTime: startTime,
                                                   endTime: endTime)
            
            
            inviteViewModel.coordinator.popInviteViewController()
        }
        
        // MARK: - 창현이가 만든 서치 버튼
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
        
        addChild(calenderViewController)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(placeView,
                                peopleView,
                                calenderViewController.view,
                                typeLabel,
                                typeSegmentedControl,
                                contentLabel,
                                titleTextField,
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
            make.width.equalTo(UIScreen.main.bounds.width * 2/3)
            make.height.equalTo(50)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.width.equalTo(UIScreen.main.bounds.width * 1/3)
            make.height.equalTo(50)
        }
        
        calenderViewController.view.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(((UIScreen.main.bounds.width) / 7) * 6 + 100)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(calenderViewController.view.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        typeSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(typeLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.width.equalTo(120)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(30)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(150)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.bottom.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Selectors
    
    @objc
    func searchFieldButtonTapped() {
        inviteViewModel.coordinator.presentSearchViewController()
    }
}
