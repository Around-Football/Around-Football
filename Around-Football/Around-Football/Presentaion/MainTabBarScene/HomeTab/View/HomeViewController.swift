//
//  HomeViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa
import Then
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel
    private var loadRecruitList = PublishSubject<(String?, String?, String?)>()
    //    private var filteringDateRecruitList = PublishSubject<String?>()
    //    private var filterringRegionRecruitList = PublishSubject<String?>()
    //    private var filteringTypeRecruitList = PublishSubject<String?>()
    private var filterRequest: (date: String?, region: String?, type: String?) = (nil, nil, nil)
    //    private var dateList: String?
    //    private var regionList: String?
    //    private var typeList: String?
    
    private var disposeBag = DisposeBag()
    
    var selectedDate: Date?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var homeTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }
    
    private lazy var filterScrollView = UIScrollView().then {
        $0.contentSize = CGSize(width: view.frame.size.width, height: 30)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var optionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.addArrangedSubviews(resetButton,
                               datePicker,
                               regionFilterButton,
                               typeFilterButton)
    }
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        
        return config
    }
    
    private lazy var resetButton = UIButton(configuration: buttonConfig).then {
        let image = UIImage(systemName: "arrow.triangle.2.circlepath")
        $0.setTitle("초기화", for: .normal)
        $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                    for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious // 버튼의 모서리를 둥글게 만듭니다.
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private lazy var dateFilterButton = UIButton(configuration: buttonConfig).then {
        let image = UIImage(systemName: "chevron.down")
        $0.setTitle("날짜 선택", for: .normal)
        $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                    for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.subviews[0].subviews[0].subviews[0].alpha = 0
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.addSubview(dateFilterButton)
        dateFilterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    private lazy var regionFilterButton: UIButton = {
        let button = UIButton(configuration: buttonConfig).then {
            let image = UIImage(systemName: "chevron.down")
            $0.setTitle("지역 선택", for: .normal)
            $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
            $0.setTitleColor(.systemGray, for: .normal)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.systemGray.cgColor
            $0.showsMenuAsPrimaryAction = true
        }
        let menus: [String]  = ["전체", "서울", "인천", "부산", "대구", "울산", "대전", "광주", "세종", "경기",
                                "강원", "충북", "충남", "경북", "경남", "전북", "전남", "제주"]
        
        button.menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                filterRequest.region = (city == "전체" ? nil : city)
                print(filterRequest)
                loadRecruitList.onNext(filterRequest)
                //                self?.filterringRegionRecruitList.onNext(city == "전체" ? nil : city)
                button.setTitle(city, for: .normal)
            }
        })
        
        return button
    }()
    
    private lazy var typeFilterButton: UIButton = {
        let button = UIButton(configuration: buttonConfig).then {
            let image = UIImage(systemName: "chevron.down")
            $0.setTitle("매치 유형", for: .normal)
            $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
            $0.setTitleColor(.systemGray, for: .normal)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.systemGray.cgColor
            $0.showsMenuAsPrimaryAction = true
        }
        
        let menus: [String] = ["전체", "풋살", "축구"]
        
        button.menu = UIMenu(children: menus.map { type in
            UIAction(title: type) { [weak self] _ in
                guard let self else { return }
                filterRequest.type = (type == "전체" ? nil : type)
                print(filterRequest)
                loadRecruitList.onNext(filterRequest)
                //                self?.filteringTypeRecruitList.onNext(type == "전체" ? nil : type)
                button.setTitle(type, for: .normal)
            }
        })
        
        return button
    }()
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
        config.image = image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20,
                                                                            weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        //        loadRecruitList.onNext(())
        //        filteringDateRecruitList.onNext(nil)
        filterRequest = (nil, nil, nil)
        print(filterRequest)
        loadRecruitList.onNext(filterRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 120
        
        floatingButton.frame = CGRect(
            x: view.frame.size.width - 70,
            y: view.frame.size.height - (tabBarHeight * 2),
            width: 50,
            height: 50
        )
    }
    
    // MARK: - Selectors
    @objc
    private func resetButtonTapped() {
        filterRequest = (nil, nil, nil)
        print(filterRequest)
        loadRecruitList.onNext(filterRequest)
        //        filteringDateRecruitList.onNext(nil)
        dateFilterButton.setTitle("날짜 선택", for: .normal)
        regionFilterButton.setTitle("지역 선택", for: .normal)
        typeFilterButton.setTitle("유형 선택", for: .normal)
    }
    
    @objc
    func changeDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "YYYY년 MM월 d일"
        let formattedDate = dateformatter.string(from: sender.date)
        
        let titleDateformatter = DateFormatter()
        titleDateformatter.locale = Locale(identifier: "ko_KR")
        titleDateformatter.dateFormat = "MM월 d일"
        let buttonTitleDate = titleDateformatter.string(from: sender.date)
        
        dateFilterButton.setTitle(buttonTitleDate, for: .normal)
        
        //onnext로 날짜에 matchDateString쿼리 날리기
        //        filteringDateRecruitList.onNext(formattedDate)
        filterRequest.date = formattedDate
        print(filterRequest)
        loadRecruitList.onNext(filterRequest)
    }
    
    @objc
    private func didTapFloatingButton() {
        if UserService.shared.user?.id == nil {
            viewModel.coordinator?.presentLoginViewController()
        } else {
            viewModel.coordinator?.pushInviteView()
        }
    }
    
    // MARK: - Helpers
    
    func bindUI() {
        let input = HomeViewModel.Input(loadRecruitList: loadRecruitList.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .recruitList
            .bind(to: homeTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.bindContents(item: item)
            }.disposed(by: disposeBag)
        
        homeTableView.rx.modelSelected(Recruit.self)
            .subscribe(onNext: { [weak self] selectedRecruit in
                guard let self else { return }
                handleItemSelected(selectedRecruit)
            })
            .disposed(by: disposeBag)
    }
    
    func handleItemSelected(_ item: Recruit) {
        viewModel.coordinator?.pushToDetailView(recruitItem: item)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(filterScrollView,
                         homeTableView,
                         floatingButton)
        
        filterScrollView.addSubview(optionStackView)
        filterScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(50)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView)
            make.leading.equalTo(filterScrollView)
            make.trailing.equalTo(filterScrollView)
            make.bottom.equalTo(filterScrollView)
        }
        
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
