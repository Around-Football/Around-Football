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
    let acceptButtonTappedSubject = PublishSubject<(String, String)>()
    let rejectButtonTappedSubject = PublishSubject<(String, String)>()
    
    private let headerView = ApplicationListHeaderView()
    
    private lazy var tableView = UITableView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = AFColor.grayScale50.cgColor
        $0.register(ApplicantListTableViewCell.self, forCellReuseIdentifier: ApplicantListTableViewCell.cellID)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
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
        configureUI()
//        bind()
        invokedViewDidLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "신청 현황"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
        navigationController?.navigationBar.tintColor = AFColor.grayScale200
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func bind() {
//        let input = ApplicantListViewModel.Input(loadApplicantList: invokedViewDidLoad,
//                                                 acceptButtonTapped: acceptButtonTappedSubject.asObservable(),
//                                                 rejectButtonTapped: rejectButtonTappedSubject.asObservable())
//        
//        let output = viewModel.transform(input)
//        
//        output
//            .applicantList
//            .bind(to: tableView.rx.items(cellIdentifier: ApplicantListTableViewCell.cellID,
//                                         cellType: ApplicantListTableViewCell.self)) { [weak self]  index, item, cell in
//                guard let self else { return }
//                cell.vc = self
//                cell.viewModel = viewModel
//                cell.uid = item
//                cell.bindUI(uid: item)
//            }
//            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
        
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(headerView,
                         tableView)
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}


