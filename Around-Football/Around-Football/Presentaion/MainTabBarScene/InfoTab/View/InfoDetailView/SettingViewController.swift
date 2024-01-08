//
//  SettingViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/6/23.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class SettingViewController: UIViewController {
    
    //설정뷰 Section 나누기위한 DataSource
    typealias SectionModel = AnimatableSectionModel<String, String>
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    private var dataSource: DataSource!
    
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
        
        setSectionTableView()
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
        
        // MARK: - Section에 따라 설정
        
        settingTableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let self else { return }
                
                switch indexPath.section {
                case 0:
                    switch indexPath.row {
                    case 0:
                        print("로그아웃 alert")
                        showPopUp(title: "로그아웃",
                                  message: "로그아웃 하시겠습니까?",
                                  rightActionCompletion: viewModel?.logout)
                    case 1:
                        print("탈퇴 alert")
                        showPopUp(title: "회원 탈퇴",
                                  message: "정말로 탈퇴 하시겠습니까?",
                                  rightActionCompletion: viewModel?.withDraw)
                    case 2:
                        print("알림 설정 하기")
                    default:
                        print("SettingCell없음")
                        return
                    }
                    
                case 1:
                    
                    switch indexPath.row {
                    case 0:
                        print("1:1 문의 뷰로")
                        sendEmail()
                    case 1:
                        print("약관 및 정책 뷰로")
                        viewModel?.coordinator?.pushWebViewController(url: "https://www.notion.so/thekoon0456/899108fe75174f91b09294adfae9de06")
                    default:
                        print("SettingCell없음")
                        return
                    }
                default:
                    print("잘못된 섹션입니다.")
                }
                
                //cell 선택 초기화
                settingTableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
    }
}

extension SettingViewController {
    func setSectionTableView() {
        // 데이터 소스 초기화
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { (_, tableView, indexPath, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.cellID, for: indexPath) as! InfoCell
                cell.setValues(title: item, usingRightIcon: false)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
            }
        )
        
        // 데이터 생성
        let section1 = SectionModel(model: "일반", items: ["로그아웃", "회원 탈퇴", "알림 설정"])
        let section2 = SectionModel(model: "서비스", items: ["1:1 문의", "약관 및 정책"])
        let sections: [SectionModel] = [section1, section2]
        let sectionsObservable = Observable.just(sections)
        
        sectionsObservable
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
