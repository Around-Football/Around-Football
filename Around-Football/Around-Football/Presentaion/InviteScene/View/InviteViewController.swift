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
    var viewModel: InviteViewModel
    var searchViewModel = SearchViewModel()
    private let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    private let calenderViewController = CalenderViewController()
    let contentView = UIView()
    
    private var id = UserService.shared.user?.id
    private var userName = UserService.shared.user?.userName
    private var fieldID = UUID().uuidString
    private lazy var recruitedPeopleCount = peopleView.count
    private lazy var content = contentTextView.text
    private lazy var matchDate = calenderViewController.selectedDateString
    private lazy var startTime = calenderViewController.selectedDate
    //TODO: - EndTime 추가
    private lazy var endTime = calenderViewController.selectedDate
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "내용"
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.addSubview(placeHolderLabel)
        placeHolderLabel.frame = CGRect(x: 5, y: 0, width: 300, height: 30)
    }
    
    let placeHolderLabel = UILabel().then {
        $0.text = "내용을 입력해주세요"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    
    private lazy var addButton = AFButton(frame: .zero, buttonTitle: "등록하기")
    
    // MARK: - Lifecycles
    
    init(viewModel: InviteViewModel, searchViewModel: SearchViewModel) {
        self.viewModel = viewModel
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
    
    // MARK: - Helpers
    
    private func setAddButton() {
        addButton.buttonActionHandler = { [weak self] in
            guard let self else { return }
            
            viewModel.createRecruitFieldData(user: UserService.shared.user ?? User(dictionary: [:]),
                                             fieldID: fieldID,
                                             recruitedPeopleCount: recruitedPeopleCount,
                                             content: content,
                                             matchDate: matchDate,
                                             startTime: startTime,
                                             endTime: endTime)
            
            viewModel.coordinator.popInviteViewController()
        }
        
        // MARK: - 창현이가 만든 서치 버튼
        placeView.searchFieldButton.addTarget(self,
                                              action: #selector(searchFieldButtonTapped),
                                              for: .touchUpInside)
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
            make.height.equalTo(((UIScreen.main.bounds.width - 40) / 7) * 6 + 100)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(calenderViewController.view.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
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
        let searchController = SearchViewController()
        searchController.viewModel = self.viewModel
        present(searchController, animated: true, completion: nil)
    }
}
