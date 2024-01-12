//
//  ApplicationStatusViewController.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ApplicantListViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: ApplicantListViewModel
    private var disposeBag = DisposeBag()
    
    private let invokedViewDidLoad = PublishSubject<Void>()
    
    private let headerView = ApplicantListHeaderView()
    
    private lazy var tableView = UITableView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = AFColor.grayScale50.cgColor
        $0.register(ApplicantListTableViewCell.self, forCellReuseIdentifier: ApplicantListTableViewCell.cellID)
        $0.delegate = self
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    private lazy var emptyView = EmptyAFView(type: EmptyAFView.SettingTitle.noApplicant).then {
        $0.isHidden = true
    }
    
    let loadingView = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: ApplicantListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "신청 현황"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
        
        viewModel.removeChildCoordinator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(headerView,
                         tableView,
                         emptyView,
                         loadingView)
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func bind() {
        let input = ApplicantListViewModel.Input(invokedViewDidLoad: invokedViewDidLoad)
        let output = viewModel.transform(input)
        
        bindRecruit()
        bindTableView(in: output.userList)
    }
    
    func bindRecruit() {
        viewModel.recruitItem
            .withUnretained(self)
            .subscribe(onNext: { (owner, recruit) in
                self.headerView.configure(recruit: recruit)
                if !recruit.pendingApplicantsUID.isEmpty { owner.emptyView.isHidden = true }
                else { owner.emptyView.isHidden = false }
            })
            .disposed(by: disposeBag)
    }
    
    func bindTableView(in observe: Observable<[User]>) {
        observe
            .bind(to: tableView.rx.items(cellIdentifier: ApplicantListTableViewCell.cellID,
                                         cellType: ApplicantListTableViewCell.self))
        { [weak self] index, user, cell in
            guard let self = self else { return }
            let applicantStatus = self.viewModel.emitApplicantStatusCalculator(uid: user.id)
            cell.configure(user: user)
            cell.setButtonStyle(status: applicantStatus)
            cell.bind {
                if applicantStatus == .accepted {
                    self.loadingView.startAnimating()
                    self.viewModel.cancelApplicantion(user: user)
                } else {
                    self.loadingView.startAnimating()
                    self.viewModel.acceptApplicantion(user: user)
                }
            } messageAction: {
                self.viewModel.checkChannelAndPushChatViewController(user: user)
            }
        }
        .disposed(by: self.disposeBag)
        
        observe
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.loadingView.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
}
