//
//  InfoViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa

final class InfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: InfoViewModel
    private var disposeBag = DisposeBag()
    private let detailUserInfoView = DetailUserInfoView()
    private let infoHeaderView = InfoHeaderView()
    
    private lazy var infoTableView = UITableView().then {
        $0.register(InfoCell.self, forCellReuseIdentifier: InfoCell.cellID)
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let lineView2 = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUserInfo()
        bindTableView()
        bindLogoutButton()
        configureSettingButton()
    }
    
    // MARK: - Selectors
    
    @objc
    func logoutButtonTapped() {
        UserService.shared.logout()
        viewModel.coordinator?.presentLoginViewController()
        tabBarController?.selectedIndex = 0 //로그아웃하면 메인탭으로 이동
    }
    
    // MARK: - Helpers
    
    private func configureSettingButton() {
        infoHeaderView.settingButtonActionHandler = { [weak self] in
            guard let self else { return }
            viewModel.coordinator?.pushSettingView()
        }
    }
    
    private func bindTableView() {
        let menus = Observable.just(viewModel.menus)
        
        menus.bind(to: infoTableView.rx.items(cellIdentifier: InfoCell.cellID,
                                              cellType: InfoCell.self)) { index, item, cell in
            cell.setValues(title: item)
        }.disposed(by: disposeBag)
        
        infoTableView.rx.modelSelected(String.self)
            .subscribe { [weak self] cellTitle in
                guard let self else { return }
                
                switch cellTitle {
                case "내 정보 수정":
                    viewModel.coordinator?.pushEditView()
                case "관심 글":
                    viewModel.coordinator?.pushBookmarkPostViewController()
                case "신청 글":
                    viewModel.coordinator?.pushWrittenPostViewController()
                case "작성 글":
                    viewModel.coordinator?.pushApplicationPostViewController()
                default:
                    print("DEBUG: cell없음")
                }
            }.disposed(by: disposeBag)
        
    }
    
    private func bindLogoutButton() {
        UserService.shared.currentUser_Rx.bind { [weak self] user in
            guard let self else { return }
            if user?.id == nil {
                logoutButton.setTitle("로그인", for: .normal)
            } else {
                logoutButton.setTitle("로그아웃", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindUserInfo() {
        UserService.shared.currentUser_Rx.bind { [weak self] user in
            guard let self else { return }
            detailUserInfoView.setValues(user: user, isSettingView: true)
        }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = "내 정보"
        
        view.addSubviews(infoHeaderView,
                         detailUserInfoView,
                         lineView,
                         infoTableView,
                         lineView2)
        
        view.addSubview(logoutButton)
        
        infoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(infoHeaderView.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(64)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
        
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(256)
        }
        
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(infoTableView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
}
