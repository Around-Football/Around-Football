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
    
    // MARK: - Properties
    
    private let homeViewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecyles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        //        tableView.delegate = nil
        tableView.dataSource = nil

        configureUI()
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        floatingButton.frame.origin.x = UIScreen.main.bounds.width - 60
//        // floatingButton.frame.origin.y = UIScreen.main.bounds.height - 30
//        floatingButton.frame.origin.y = UIScreen.main.bounds.height - optionStackView.frame.origin.y + scrollView.contentOffset.y
//        print("floatingButton: \(floatingButton.frame.origin.y)")
//        print("scrollView: \(scrollView.contentOffset.y)")
//        print("UIScreen: \(UIScreen.main.bounds.height)")
//        print("view: \(view.frame.height)")
//    }
    
    func configureUI() {
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
    }
    
    // MARK: - Selectors
    
    @objc func filterOptionTapped(sender: UIButton) {
        // 필터 옵션 버튼을 탭했을 때의 동작을 구현하세요.
        if let optionTitle = sender.title(for: .normal) {
            print("Selected Filter: \(optionTitle)")
            // 여기에 필터링 로직을 추가하십시오.
        }
    }
    
    @objc func didTapFloatingButton() {
        
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


