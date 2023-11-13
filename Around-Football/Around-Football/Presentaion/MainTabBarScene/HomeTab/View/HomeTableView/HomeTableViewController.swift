//
//  HomeTableViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeTableViewController: UITableViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        tableView.dataSource = nil
        
        viewModel.recruitObservable
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.coordinator?.pushToDetailView()
    }
}


