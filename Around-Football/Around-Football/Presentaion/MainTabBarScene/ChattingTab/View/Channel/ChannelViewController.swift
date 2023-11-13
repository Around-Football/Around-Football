//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class ChannelViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: ChannelViewModel
    let disposeBag = DisposeBag()
    
    private let invokedViewDidLoad = BehaviorSubject<Void>(value: ())
    
    lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.cellId)
        $0.delegate = self
    }
    
    private let loginLabel = UILabel().then {
        $0.text = """
        로그인이 필요한 서비스입니다.
        로그인을 해주세요.
        """
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: ChannelViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        title = "채팅"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        invokedViewDidLoad.onNext(())
        bind()
//        viewModel.setupListener()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubviews(
            channelTableView,
            loginLabel
        )
        channelTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        loginLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = ChannelViewModel.Input(invokedViewDidLoad: invokedViewDidLoad.asObservable())
        
        let output = viewModel.transform(input)
        
        bindCurrentUser(with: output.currentUser)
    }
    
    private func bindCurrentUser(with outputObservable: Observable<User?>) {
        outputObservable
            .withUnretained(self)
            .do(onNext: { (owner, user) in
                if user == nil {
                    print("currentUser nil")
                    owner.viewModel.coordinator?.presentLoginViewController()
                }
            })
            .map { $0.1 == nil }
            .bind(to: loginLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputObservable
            .map { $0 != nil }
            .bind(to: channelTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
