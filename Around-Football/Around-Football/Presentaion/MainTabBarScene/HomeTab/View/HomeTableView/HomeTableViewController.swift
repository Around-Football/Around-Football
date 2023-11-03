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
    
    private func configureUI() {
        homeViewModel.recruitObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.id,
                                         cellType: HomeTableViewCell.self)
            ) { index, item, cell in
                cell.titleLabel.text = "(장소) \(item.fieldName)"
                cell.dateLabel.text = "(날짜) \(item.matchDate)"
                cell.fieldAddress.text = "(주소) \(item.fieldAddress)"
                cell.recruitLabel.text = "(용병 수) \(item.people)/10 명"
                cell.timeLabel.text = item.matchTime
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Selectors
    
    
    // UITableViewDataSource 메서드
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return items.count
    //    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailViewController()
         present(nextVC, animated: true)
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as! HomeTableViewCell
    //        cell.titleLabel.text = items[indexPath.row]
    //        // 나머지 셀 내용을 설정하려면 HomeTableViewCell에 해당 프로퍼티 및 메서드를 추가하십시오.
    //        return cell
    //    }
}


