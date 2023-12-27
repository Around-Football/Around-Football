//
//  SettingViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/6/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: SettingViewModel?
    private let disposeBag = DisposeBag()
    
    private let settingTableView = UITableView().then {
        $0.register(InfoCell.self, forCellReuseIdentifier: InfoCell.cellID)
    }
    
    
    // MARK: - Lifecycles
    
    init(viewModel: SettingViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    // MARK: - Helpers
    
    private func bindUI() {
        viewModel?
            .settingMenusObserverble
            .bind(to: settingTableView.rx.items(cellIdentifier: InfoCell.cellID,
                                                cellType: InfoCell.self)) { index, item, cell in
                cell.setValues(title: item)
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "더 보기"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
