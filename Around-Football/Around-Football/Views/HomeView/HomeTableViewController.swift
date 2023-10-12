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
    
    private let disposeBag = DisposeBag()
    
    private var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    private let filterOptions: [String] = ["날짜별", "지역별", "매치 유형별"] // 필터 옵션
    
    private lazy var filterScrollView = UIScrollView().then {
        $0.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        $0.showsHorizontalScrollIndicator = true
    } // 가로 스크롤뷰
    
    private var optionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
        configureUI()
    }
    
    func configureUI() {

        for option in filterOptions {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.black, for: .normal)
//            button.backgroundColor = .blue
            button.layer.cornerRadius = 15 // 둥근 모서리 설정
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.black.cgColor
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.sizeToFit()
            
            optionStackView.addArrangedSubview(button)
        }

        // UIStackView를 가로 스크롤뷰에 추가
        filterScrollView.addSubview(optionStackView)
        filterScrollView.showsHorizontalScrollIndicator = false
        
        tableView.tableHeaderView = filterScrollView
        
        optionStackView.snp.makeConstraints { make in
            make.width.equalTo(filterScrollView)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
        }
    }
    
    private func calculateTotalButtonWidth() -> CGFloat {
        var totalWidth: CGFloat = 0
        for option in filterOptions {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.sizeToFit()
            totalWidth += button.frame.size.width
        }
        return totalWidth
    }
    
    @objc func filterOptionTapped(sender: UIButton) {
        // 필터 옵션 버튼을 탭했을 때의 동작을 구현하세요.
        if let optionTitle = sender.title(for: .normal) {
            print("Selected Filter: \(optionTitle)")
            // 여기에 필터링 로직을 추가하십시오.
        }
    }
    // UITableViewDataSource 메서드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as! HomeTableViewCell
        cell.titleLabel.text = items[indexPath.row]
        // 나머지 셀 내용을 설정하려면 HomeTableViewCell에 해당 프로퍼티 및 메서드를 추가하십시오.
        return cell
    }
}


