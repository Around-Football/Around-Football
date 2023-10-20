//
//  HomeViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//
// 홈(리스트)
import UIKit
import RxSwift
import Then
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeTableViewController = HomeTableViewController()
    
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
        addChild(homeTableViewController)
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
    
    func configureUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
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
                         homeTableViewController.view,
                         floatingButton)
        
        homeTableViewController.didMove(toParent: self)
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView)
            make.leading.equalTo(filterScrollView)
            make.trailing.equalTo(filterScrollView)
            make.bottom.equalTo(filterScrollView)
        }
        
        filterScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(90)
            make.width.equalTo(view.frame.size.width)
        }
        
        homeTableViewController.view.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    
    @objc
    func filterOptionTapped(sender: UIButton) {
        // 필터 옵션 버튼을 탭했을 때의 동작을 구현하세요.
        if let optionTitle = sender.title(for: .normal) {
            print("Selected Filter: \(optionTitle)")
            // 여기에 필터링 로직을 추가하십시오.
        }
    }
    
    @objc
    func didTapFloatingButton() {
        
    }
}
