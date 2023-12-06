//
//  InviteViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

//TODO: - 게임비 항목 추가, Recruit 모델 수정

final class InviteViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: InviteViewModel
    private var searchViewModel: SearchViewModel
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    let contentView = UIView()
    private let placeView = GroundTitleView()
    private let peopleView = PeopleCountView()
    private let calenderViewController = CalenderViewController()
    
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
        viewModel.type.accept("풋살")
        $0.addTarget(self,
                     action: #selector(segmentedControlValueChanged),
                     for: .valueChanged)
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "내용"
    }
    
    private let gamePriceLabel = UILabel().then {
        $0.text = "게임비"
    }
    
    private lazy var gamePriceButton: UIButton = {
        let button = UIButton().then {
            $0.setTitle("선택하기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.setTitleColor(.label, for: .normal)
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                                      leading: 10,
                                                                      bottom: 10,
                                                                      trailing: 10)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.showsMenuAsPrimaryAction = true
        }
        
        let prices: [String]  = ["무료", "5,000원", "10,000원",
                                 "15,000원", "20,000원", "30,000원", "기타"]
        
        button.menu = UIMenu(children: prices.map { price in
            UIAction(title: price) { [weak self] _ in
                guard let self else { return }
                viewModel.gamePrice.accept(price)
                button.setTitle(price, for: .normal)
            }
        })
        
        return button
    }()
    
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
        self.viewModel = inviteViewModel
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
    
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.type.accept(sender.titleForSegment(at: sender.selectedSegmentIndex))
    }
    
    @objc
    func searchFieldButtonTapped() {
        viewModel.coordinator.presentSearchViewController()
    }
    
    // MARK: - Helpers
    
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
        
        //TODO: - 다 입력했을때 버튼 활성화되도록 수정
        //        addButton.setTitle("항목을 모두 입력해주세요", for: .normal)
        //        addButton.setTitleColor(.gray, for: .normal)
        
        addButton.buttonActionHandler = { [weak self] in
            guard let self else { return }
            // MARK: - 다 채웠을때만 활성화하기
            
            viewModel.createRecruitFieldData(peopleCount: peopleView.count,
                                             contentTitle: titleTextField.text,
                                             content: contentTextView.text,
                                             matchDateString: calenderViewController.selectedDateString,
                                             startTime: calenderViewController.startTimeString,
                                             endTime: calenderViewController.endTimeString)
            
            addButton.setTitle("등록하기", for: .normal)
            viewModel.coordinator.popInviteViewController()
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
                                gamePriceLabel,
                                gamePriceButton,
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
        
        gamePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        gamePriceButton.snp.makeConstraints { make in
            make.centerY.equalTo(gamePriceLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(gamePriceLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
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
}
