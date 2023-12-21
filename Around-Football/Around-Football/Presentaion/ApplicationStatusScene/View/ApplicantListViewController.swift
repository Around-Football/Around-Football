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
    
    private let tableView = UITableView().then {
        $0.register(ApplicantListTableViewCell.self, forCellReuseIdentifier: ApplicantListTableViewCell.cellID)
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
        setupTableViewConstraints()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    func bind() {
        let input = ApplicantListViewModel.Input(loadApplicantList: invokedViewDidLoad,
                                                 acceptButtonTapped: acceptButtonTappedSubject.asObservable(),
                                                 rejectButtonTapped: rejectButtonTappedSubject.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .applicantList
            .bind(to: tableView.rx.items(cellIdentifier: ApplicantListTableViewCell.cellID,
                                         cellType: ApplicantListTableViewCell.self)) { [weak self]  index, item, cell in
                guard let self else { return }
                cell.vc = self
                cell.viewModel = viewModel
                cell.uid = item
                cell.bindUI(uid: item)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}


