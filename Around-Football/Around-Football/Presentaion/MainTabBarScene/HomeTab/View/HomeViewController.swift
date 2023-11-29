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
    let dateFilterView = DateFilterViewController()
    let locationFilterView = LocationFilterViewController()
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var filteringTypeRecruitList = PublishSubject<String?>()
    private var filterringRegionRecruitList = PublishSubject<String?>()
    private var disposeBag = DisposeBag()
    
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
        $0.addArrangedSubviews(resetButton, dateFilterButton, areaFilterButton, typeFilterButton)
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
        $0.addTarget(self, action: #selector(resetFilterButtonTapped), for: .touchUpInside)
    }
    
    private lazy var dateFilterButton = UIButton(configuration: buttonConfig).then {
        let image = UIImage(systemName: "chevron.down")
        $0.setTitle("날짜 선택", for: .normal)
        $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(dateFilterButtonTapped), for: .touchUpInside)
    }
    
    private lazy var areaFilterButton = UIButton(configuration: buttonConfig).then {
        let image = UIImage(systemName: "chevron.down")
        $0.setTitle("지역 선택", for: .normal)
        $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(areaFilterButtonTapped), for: .touchUpInside)
    }
    
    private lazy var typeFilterButton = UIButton(configuration: buttonConfig).then {
        let image = UIImage(systemName: "chevron.down")
        $0.setTitle("매치 유형", for: .normal)
        $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(typeFilterButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func resetFilterButtonTapped() {
        
    }
    
    @objc
    func dateFilterButtonTapped() {
        
    }
    
    @objc
    func areaFilterButtonTapped() {
        
    }
    
    @objc
    func typeFilterButtonTapped() {
        
    }
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        //        invokedViewWillAppear.onNext(())
        filterringRegionRecruitList.onNext(locationFilterView.selectedCity)
//        print(locationFilterView.selectedCity)
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
    
    // MARK: - Helpers
    
    func bindUI() {
        let input = HomeViewModel.Input(invokedViewWillAppear: invokedViewWillAppear.asObservable(),
                                        filteringType: filteringTypeRecruitList.asObservable(),
                                        filteringRegion: filterringRegionRecruitList.asObserver())
        
        let output = viewModel.transform(input)
        
        //merge: 하나만 있어도 내려보냄
        Observable
            .merge(output.recruitList,
                   output.filteredTypeRecruitList,
                   output.filteredRegionRecruitList)
            .bind(to: homeTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                             cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.bindContents(item: item)
            }.disposed(by: disposeBag)
        
        homeTableView.rx.modelSelected(Recruit.self)
            .subscribe(onNext: { [weak self] selectedRecruit in
                guard let self = self else { return }
                self.handleItemSelected(selectedRecruit)
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
    
//    //TODO: - 방식 맞추기 (모달 or alertsheet)
//    
//    func matchTypeActionSheet() -> UIAlertController {
//        let actionSheet = UIAlertController()
//        
//        actionSheet.title = "매치 유형을 선택해주세요"
//        
//        //전체 버튼 - 스타일(default)
//        actionSheet.addAction(UIAlertAction(title: "전체", style: .default, handler: {[weak self] (ACTION:UIAlertAction) in
//            print("전체")
//            self?.filteringTypeRecruitList.onNext(nil)
//        }))
//        
//        // 축구
//        actionSheet.addAction(UIAlertAction(title: "축구", style: .default, handler: { [weak self] _ in
//            print("축구")
//            self?.filteringTypeRecruitList.onNext("축구")
//        }))
//        
//        // 풋살
//        actionSheet.addAction(UIAlertAction(title: "풋살", style: .default, handler: { [weak self] _ in
//            print("풋살")
//            self?.filteringTypeRecruitList.onNext("풋살")
//        }))
//        
//        //취소 버튼 - 스타일(cancel)
//        actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
//        
//        return actionSheet
//    }

    
//    let typeItems = ["전체, 축구, 풋살"]
//    
//    private lazy var pickerView: UIPickerView = {
//        
//        let pickerView = UIPickerView()
//        
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        return pickerView
//    }()
//    
//    private lazy var textField: UITextField = {
//        let textfield = UITextField()
//        textfield.inputView = pickerView
//        return textfield
//    }()

//    
//    private let typePickerView = UIPickerView()
    
//    private func setupTypePicker() {
//        typePickerView.delegate = self
//        
//        Observable
//            .combineLatest(typePickerView.rx.itemSelected, typePickerView.rx.modelSelected(String.self))
//            .map { _, item in
//                return item.first ?? ""
//            }
////            .bind(to: textField.rx.text)
//            .disposed(by: disposeBag)
//        
//        // RxSwift와 RxCocoa를 사용하여 피커 뷰의 데이터 소스를 설정
//        Observable
//            .just(typeItems)
//            .bind(to: typePickerView.rx.itemTitles) { _, item in
//                return item
//            }
//            .disposed(by: disposeBag)
//    }
    
//    // MARK: - Selectors
//    
//    @objc
//    func filterOptionTapped(sender: UIButton) {
//        // TODO: - Coordinator로 변경
//        // 필터 옵션 버튼을 탭했을 때의 동작
//        // ["모든 날짜", "모든 지역", "매치 유형"]
//        
//        switch sender.title(for: .normal) {
//        case "모든 날짜":
//            present(dateFilterView, animated: true)
//            
//        case "모든 지역":
//            locationFilterView.modalPresentationStyle = .fullScreen
//            locationFilterView.modalTransitionStyle = .coverVertical
//            present(locationFilterView, animated: true)
//            
//        case "매치 유형":
//            self.present(matchTypeActionSheet(), animated: true, completion: nil)
//            
//
//        default:
//            break
//        }
//    }
    
    // FIXME: - View PopUp navigationBar 처리
    @objc
    func didTapFloatingButton() {
        if UserService.shared.user?.id == nil {
            viewModel.coordinator?.presentLoginViewController()
        } else {
            viewModel.coordinator?.pushInviteView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//          return 1
//      }
//      
//      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//          return typeItems.count
//      }
//      
//      // UIPickerViewDelegate 메서드
//      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//          return typeItems[row]
//      }
//      
//      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//          textField.text = typeItems[row]
//      }
//}
