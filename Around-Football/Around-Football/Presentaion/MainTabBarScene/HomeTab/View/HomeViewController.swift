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
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var filteringTypeRecruitList = PublishSubject<String?>()
    private var disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var homeTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }
    
    private let filterOptions: [String] = ["모든 날짜", "모든 지역", "매치 유형"] // 필터 옵션
    
    private lazy var filterScrollView = UIScrollView().then {
        $0.contentSize = CGSize(width: view.frame.size.width, height: 30)
        $0.showsHorizontalScrollIndicator = false
    } // 가로 스크롤뷰
    
    private var optionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        
        return config
    }
    
    private lazy var resetButton: UIButton = {
        
        let button = UIButton(configuration: buttonConfig)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath")
        // 버튼 타이틀과 이미지 설정
        button.setTitle("초기화", for: .normal)
        button.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
        
        // 버튼 스타일 설정
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = LayoutOptions.cornerRadious // 버튼의 모서리를 둥글게 만듭니다.
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGray.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterOptionTapped), for: .touchUpInside)
        
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
        invokedViewWillAppear.onNext(())
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
        let input = HomeViewModel.Input(invokedViewWillAppear: invokedViewWillAppear.asObservable(), filteringType: filteringTypeRecruitList.asObservable())
        
        let output = viewModel.transform(input)
        
        //merge: 둘 중 하나만 있어도 내려보냄
        Observable.merge(output.recruitList, output.filteredTypeRecruitList)
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
        
        optionStackView.addArrangedSubview(resetButton)
        
        for option in filterOptions {
            let filterButton: UIButton = {
                let button = UIButton(configuration: buttonConfig)
                let image = UIImage(systemName: "chevron.down")
                // 버튼 타이틀과 이미지 설정
                button.setTitle(option, for: .normal)
                button.setImage(
                    image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                    for: .normal)
                
                // 버튼 스타일 설정
                button.setTitleColor(.systemGray, for: .normal)
                button.layer.cornerRadius = LayoutOptions.cornerRadious
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.systemGray.cgColor
                
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(filterOptionTapped), for: .touchUpInside)
                return button
            }()
            
            optionStackView.addArrangedSubview(filterButton)
        }
        
        filterScrollView.addSubview(optionStackView)
        
        view.addSubviews(filterScrollView,
                         homeTableView,
                         floatingButton)
        
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
    
    func matchTypeActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController()
        
        actionSheet.title = "매치 유형을 선택해주세요"
        
        //전체 버튼 - 스타일(default)
        actionSheet.addAction(UIAlertAction(title: "전체", style: .default, handler: {[weak self] (ACTION:UIAlertAction) in
            print("전체")
            self?.filteringTypeRecruitList.onNext(nil)
        }))
        
        // 축구
        actionSheet.addAction(UIAlertAction(title: "축구", style: .default, handler: { [weak self] _ in
            print("축구")
            self?.filteringTypeRecruitList.onNext("축구")
        }))
        
        // 풋살
        actionSheet.addAction(UIAlertAction(title: "풋살", style: .default, handler: { [weak self] _ in
            print("풋살")
            self?.filteringTypeRecruitList.onNext("풋살")
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        
        return actionSheet
    }
    
    // MARK: - Selectors
    
    @objc
    func filterOptionTapped(sender: UIButton) {
        // FIXME: - Switch문 리팩토링 가능? -> 쌉가능
        // 필터 옵션 버튼을 탭했을 때의 동작
        // ["모든 날짜", "모든 지역", "매치 유형"]
        
        switch sender.title(for: .normal) {
        case "모든 날짜":
            let filterView = DateFilterViewController()
            present(filterView, animated: true)
            
        case "모든 지역":
            let filterView = LocationFilterViewController()
            present(filterView, animated: true)
            
        case "매치 유형":
            self.present(matchTypeActionSheet(), animated: true, completion: nil)

        default:
            break
        }
    }

    // FIXME: - View PopUp navigationBar 처리
    @objc
    func didTapFloatingButton() {
        //TODO: -FirebaseAuth UID 확인해서 로그인 or 초대뷰
        if UserService.shared.user?.id == nil {
            viewModel.coordinator?.presentLoginViewController()
        } else {
            viewModel.coordinator?.pushInviteView()
        }
        print("DEBUG: didTapFloatingButton")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
