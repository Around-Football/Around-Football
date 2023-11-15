//
//  ChannelViewController.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import FirebaseAuth
import SnapKit
import Then
import RxSwift

final class ChannelViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: ChannelViewModel
    let disposeBag = DisposeBag()
    
    private let invokedViewWillAppear = PublishSubject<Void>()
    
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
        print("init")
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        title = "채팅"

        
        print("\(Auth.auth().currentUser?.uid)")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG - Deinit (channelViewController)")
        viewModel.removeListner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
                invokedViewWillAppear.onNext(())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
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
        let input = ChannelViewModel.Input(invokedViewWillAppear: invokedViewWillAppear)
        
        let output = viewModel.transform(input)
        
        bindCurrentUser(with: output.currentUser)
        bindChannels()
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
            .map { $0.1 != nil }
            .bind(to: loginLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputObservable
            .map { $0 == nil }
            .bind(to: channelTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindChannels() {
        viewModel.channels
            .bind(to: channelTableView.rx.items(cellIdentifier: ChannelTableViewCell.cellId, cellType: ChannelTableViewCell.self)) { row, item, cell in
                cell.chatRoomLabel.text = item.withUserName
                cell.chatPreviewLabel.text = item.previewContent
                let alarmNumber = item.alarmNumber
                alarmNumber == 0 ? self.hideChatAlarmNumber(cell: cell) : self.showChatAlarmNumber(cell: cell, alarmNumber: "\(alarmNumber)")
                let date = item.recentDate
                cell.recentDateLabel.text = self.formatDate(date)
            }
            .disposed(by: disposeBag)
        
        
    }
    //        viewModel.channels.bind(to: channelTableView.rx.items(cellIdentifier: ChannelTableViewCell.cellId, cellType: ChannelTableViewCell.self)) { [weak self] row, item, cell in
    //            guard let self = self else { return }
    //            cell.chatRoomLabel.text = item.withUserName
    //            cell.chatPreviewLabel.text = item.previewContent
    //            let alarmNumber = item.alarmNumber
    //            alarmNumber == 0 ? self.hideChatAlarmNumber(cell: cell) : self.showChatAlarmNumber(cell: cell, alarmNumber: "\(alarmNumber)")
    //            let date = item.recentDate
    //            cell.recentDateLabel.text = self.formatDate(date)
    //        }
    //        .disposed(by: disposeBag)
    //
    //        channelTableView.rx.itemSelected
    //            .subscribe { [weak self] indexPath in
    //                let selectedItem = self?.viewModel.channels.value[indexPath.row]
    //                self?.viewModel.showChatView()
    //            }
    //            .disposed(by: disposeBag)
    
}
