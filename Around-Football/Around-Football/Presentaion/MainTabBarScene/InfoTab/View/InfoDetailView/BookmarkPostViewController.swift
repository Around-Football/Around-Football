//
//  BookmarkPostViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/10/23.
//

import UIKit

import SnapKit
import Then

final class BookmarkPostViewController: UIViewController {

    private var bookmarkTableView = UITableView().then {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureUI()
    }
    
//    private func bindUI() {
//        let input = HomeViewModel.Input(loadRecruitList: loadRecruitList.asObservable())
//        
//        let output = viewModel.transform(input)
//        
//        output
//            .recruitList
//            .bind(to: homeTableView.rx.items(cellIdentifier: HomeTableViewCell.id,
//                                             cellType: HomeTableViewCell.self)) { [weak self] index, item, cell in
//                guard let self else { return }
//                cell.viewModel = viewModel
//                cell.bindContents(item: item)
//                cell.configureButtonTap()
//            }.disposed(by: disposeBag)
//        
//        homeTableView.rx.modelSelected(Recruit.self)
//            .subscribe(onNext: { [weak self] selectedRecruit in
//                guard let self else { return }
//                handleItemSelected(selectedRecruit)
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func bind() {
        
    }
    
    private func configureUI() {
        view.addSubview(bookmarkTableView)
        bookmarkTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
