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
    
    private let homeTableViewController = HomeTableViewController(style: .plain)
    
    private let filterOptions: [String] = ["모든 날짜", "모든 지역", "매치 유형"] // 필터 옵션
    
    private lazy var filterScrollView = UIScrollView().then {
        $0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
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
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        return button
    }()
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return config
    }
    
    private lazy var resetButton: UIButton = {
        
        let button = UIButton(configuration: buttonConfig)
        
        // 버튼 타이틀과 이미지 설정
        button.setTitle("초기화", for: .normal)
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath")?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal), for: .normal)
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 70,
                                      y: view.frame.size.height - 100,
                                      width: 50,
                                      height: 50)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
//        addChild(homeTableViewController)
        
        view.addSubview(filterScrollView)
        view.addSubviews(homeTableViewController.view,
                         floatingButton)
        
        filterScrollView.addSubview(optionStackView)
        optionStackView.addArrangedSubview(resetButton)
        
        for option in filterOptions {
            let filterButton: UIButton = {
                let button = UIButton(configuration: buttonConfig)
                
                // 버튼 타이틀과 이미지 설정
                button.setTitle(option, for: .normal)
                button.setImage(UIImage(systemName: "chevron.down")?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal), for: .normal)
                
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
            
            optionStackView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
                make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            }
            
            filterScrollView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(SuperviewOffsets.topPadding)
                make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
                make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            }
            
            homeTableViewController.view.snp.makeConstraints { make in
                make.top.equalTo(filterScrollView.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
            }
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
