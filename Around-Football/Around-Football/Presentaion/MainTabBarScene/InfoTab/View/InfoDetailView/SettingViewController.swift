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
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
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
                cell.setValues(title: item, usingRightIcon: false)
            }.disposed(by: disposeBag)
        
//        ["알림 설정", "1:1 문의", "약관 및 정책", "로그아웃", "탈퇴"]
        settingTableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let self else { return }
                
                switch indexPath.row {
                case 0:
                    print("알림 설정 뷰로")
                case 1:
                    print("1:1 문의 뷰로")
                case 2:
                    print("약관 및 정책 뷰로")
                case 3:
                    print("로그아웃 alert")
                    UserService.shared.logout()
                case 4:
                    print("탈퇴 alert")
                    
                default:
                    print("SettingCell없음")
                    return
                }
                
                settingTableView.deselectRow(at: indexPath, animated: true)
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
