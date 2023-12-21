//
//  HomeViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

enum FilterRequest: String {
    case date = "dateKey"
    case region = "regionKey"
    case type = "typeKey"
    case gender = "genderKey"
}

struct RecruitFilter {
    var date: String?
    var region: String?
    var type: String?
    var gender: String?
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModel
    private var loadRecruitList = PublishSubject<RecruitFilter>()
//    private var filterRequest: (date: String?, region: String?, type: String?)
    private var filterRequest: RecruitFilter = RecruitFilter()
    private let disposeBag = DisposeBag()
    private var selectedDate: Date?
    
    let regionMenus: [String]  = ["모든 지역", "서울", "인천", "부산", "대구", "울산",
                            "대전", "광주", "세종특별자치시","경기", "강원특별자치도",
                            "충북", "충남", "경북", "경남", "전북", "전남", "제주특별자치도"]
    let typeMenus: [String] = ["모든 유형", "풋살", "축구"]
    let genderMenus: [String] = ["성별 무관", "남", "여"]
    
    private lazy var resetButton = AFRoundSmallButton(buttonTitle: "전체 보기", color: .black)
    private lazy var regionFilterButton = AFRoundMenuButton(buttonTitle: "모든 지역", menus: regionMenus)
    private lazy var typeFilterButton = AFRoundMenuButton(buttonTitle: "매치 유형", menus: typeMenus)
    private let dateFilterButton = AFRoundMenuButton(buttonTitle: "날짜 선택", menus: [])
    private lazy var genderFilterButton = AFRoundMenuButton(buttonTitle: "성별 선택", menus: genderMenus)
    
    private lazy var homeTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }
    
    private lazy var filterScrollView = UIScrollView().then {
        $0.contentSize = .zero
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var optionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
        $0.addArrangedSubviews(resetButton,
                               datePicker,
                               regionFilterButton,
                               typeFilterButton,
                               genderFilterButton)
    }
    
    private lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
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
        $0.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    private lazy var floatingButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.plusButton), for: .normal)
        $0.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindScrollButtons()
        setUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecruitList.onNext((filterRequest))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "용병 구해요"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }

    // MARK: - Selectors
    
    @objc
    private func resetButtonTapped() {
        dateFilterButton.isSelected = false
        regionFilterButton.isSelected = false
        typeFilterButton.isSelected = false
        
        dateFilterButton.setTitle("날짜 선택", for: .normal)
        regionFilterButton.setTitle("모든 지역", for: .normal)
        typeFilterButton.setTitle("매치 유형", for: .normal)
        
        filterRequest = RecruitFilter(date: nil, region: nil, type: nil, gender: nil)
        saveFilterRequestToUserDefaults(filterRequest: filterRequest)
        getFilterRequestFromUserDefaults()
        loadRecruitList.onNext(filterRequest)
    }
    
    @objc
    func changeDate(_ sender: UIDatePicker) {
        dateFilterButton.isSelected.toggle()
        selectedDate = sender.date
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "YYYY년 M월 d일"
        let formattedDate = dateformatter.string(from: sender.date)
        
        let titleDateformatter = DateFormatter()
        titleDateformatter.locale = Locale(identifier: "ko_KR")
        titleDateformatter.dateFormat = "M월 d일"
        let buttonTitleDate = titleDateformatter.string(from: sender.date)
        
        filterRequest.date = formattedDate
        saveFilterRequestToUserDefaults(filterRequest: filterRequest)
        getFilterRequestFromUserDefaults()
        dateFilterButton.setTitle(buttonTitleDate, for: .normal)
        loadRecruitList.onNext(filterRequest)
    }
    
    @objc
    private func didTapFloatingButton() {
        do {
            let user = try UserService.shared.currentUser_Rx.value()
            if user == nil {
                viewModel.coordinator?.presentLoginViewController()
            } else {
                viewModel.coordinator?.pushInviteView()
            }
        } catch {
            print("로그인 정보 가져오기 오류")
        }
    }
    
    // MARK: - Helpers
    
    //유저디폴트 저장
    func saveFilterRequestToUserDefaults(filterRequest: RecruitFilter) {
        UserDefaults.standard.set(filterRequest.date, forKey: FilterRequest.date.rawValue)
        UserDefaults.standard.set(filterRequest.region, forKey: FilterRequest.region.rawValue)
        UserDefaults.standard.set(filterRequest.type, forKey: FilterRequest.type.rawValue)
        UserDefaults.standard.set(filterRequest.gender, forKey: FilterRequest.gender.rawValue)
    }
    
    //유저디폴트 값 설정
    func getFilterRequestFromUserDefaults() {
        let date = UserDefaults.standard.string(forKey: FilterRequest.date.rawValue)
        let region = UserDefaults.standard.string(forKey: FilterRequest.region.rawValue)
        let type = UserDefaults.standard.string(forKey: FilterRequest.type.rawValue)
        let gender = UserDefaults.standard.string(forKey: FilterRequest.gender.rawValue)
        self.filterRequest = RecruitFilter(date: date, region: region, type: type, gender: gender)
    }
    
    //유저 지역 정보로 필터링하고 리스트 요청
    private func setUserInfo() {
        UserService.shared.currentUser_Rx
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                getFilterRequestFromUserDefaults()
                dateFilterButton.menuButtonSubject.onNext(filterRequest.date)
                regionFilterButton.menuButtonSubject.onNext(filterRequest.region)
                typeFilterButton.menuButtonSubject.onNext(filterRequest.type)
            }).disposed(by: disposeBag)
    }
    
    private func bindScrollButtons() {
        resetButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            resetButtonTapped()
            resetButton.isSelected = true
        }.disposed(by: disposeBag)
        
        dateFilterButton.menuButtonSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] button in
                guard let self else { return }
                if let button {
                    resetButton.isSelected = false
                    dateFilterButton.isSelected = true
                    filterRequest.date = button
                    saveFilterRequestToUserDefaults(filterRequest: filterRequest)
                    getFilterRequestFromUserDefaults()
                    loadRecruitList.onNext(filterRequest)
                } else {
                    dateFilterButton.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        regionFilterButton.menuButtonSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] button in
                guard let self else { return }
                if let button {
                    print(button)
                    resetButton.isSelected = false
                    regionFilterButton.isSelected = true
                    filterRequest.region = button
                    saveFilterRequestToUserDefaults(filterRequest: filterRequest)
                    getFilterRequestFromUserDefaults()
                    loadRecruitList.onNext(filterRequest)
                } else {
                    regionFilterButton.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        typeFilterButton.menuButtonSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] button in
                guard let self else { return }
                if let button {
                    resetButton.isSelected = false
                    typeFilterButton.isSelected = true
                    filterRequest.type = button
                    saveFilterRequestToUserDefaults(filterRequest: filterRequest)
                    getFilterRequestFromUserDefaults()
                    loadRecruitList.onNext(filterRequest)
                } else {
                    typeFilterButton.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        genderFilterButton.menuButtonSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] button in
                guard let self else { return }
                if let button {
                    resetButton.isSelected = false
                    genderFilterButton.isSelected = true
                    //TODO: - gender 추가
                    filterRequest.gender = button == "성별 무관" ? nil : button
                    saveFilterRequestToUserDefaults(filterRequest: filterRequest)
                    getFilterRequestFromUserDefaults()
                    loadRecruitList.onNext(filterRequest)
                } else {
                    typeFilterButton.isSelected = false
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindUI() {
        let input = HomeViewModel.Input(loadRecruitList: loadRecruitList.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .recruitList
            .bind(to: homeTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { [weak self] index, item, cell in
                guard let self else { return }
                cell.viewModel = viewModel
                cell.bindContents(item: item)
                cell.configureButtonTap()
            }.disposed(by: disposeBag)
        
        homeTableView.rx.modelSelected(Recruit.self)
            .subscribe(onNext: { [weak self] selectedRecruit in
                guard let self else { return }
                handleItemSelected(selectedRecruit)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleItemSelected(_ item: Recruit) {
        viewModel.coordinator?.pushToDetailView(recruitItem: item)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(filterScrollView,
                         homeTableView,
                         floatingButton)
        filterScrollView.addSubview(optionStackView)
        
        filterScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(32)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.edges.equalTo(filterScrollView)
            make.height.equalTo(32)
        }
        
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.width.equalTo(56)
        }
    }
}
