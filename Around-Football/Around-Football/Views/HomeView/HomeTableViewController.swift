//
//  HomeTableViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class HomeTableViewController: UITableViewController {
    
    private let homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
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
    }
    
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
    
    private lazy var recruitButton = UIButton().then {
        $0.setTitle("용병 구하기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
//        tableView.delegate = nil
        tableView.dataSource = nil

        homeViewModel.recruitObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.id, 
                                         cellType: HomeTableViewCell.self)
            ) { index, item, cell in
                cell.titleLabel.text = item.fieldName
                cell.dateLabel.text = item.matchDate
                cell.fieldAddress.text = item.fieldAddress
                cell.recruitLabel.text = "\(item.people)"
                cell.timeLabel.text = item.matchTime
            }
            .disposed(by: disposeBag)

        configureUI()
    }

    func configureUI() {
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
        }
        
        // UIStackView를 가로 스크롤뷰에 추가
        filterScrollView.addSubview(optionStackView)
        filterScrollView.showsHorizontalScrollIndicator = false
        
        tableView.tableHeaderView = filterScrollView
        
        view.addSubview(recruitButton)
        recruitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
    }
    
    @objc func filterOptionTapped(sender: UIButton) {
        // 필터 옵션 버튼을 탭했을 때의 동작을 구현하세요.
        if let optionTitle = sender.title(for: .normal) {
            print("Selected Filter: \(optionTitle)")
            // 여기에 필터링 로직을 추가하십시오.
        }
    }
    // UITableViewDataSource 메서드
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as! HomeTableViewCell
//        cell.titleLabel.text = items[indexPath.row]
//        // 나머지 셀 내용을 설정하려면 HomeTableViewCell에 해당 프로퍼티 및 메서드를 추가하십시오.
//        return cell
//    }
}


