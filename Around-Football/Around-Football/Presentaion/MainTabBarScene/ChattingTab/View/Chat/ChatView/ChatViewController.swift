//
//  ChatViewController.swift
//  Around-Football
//
//  Created by 진태영 on 12/15/23.
//

import UIKit

import SnapKit
import Then
import RxSwift

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ChatViewModel
    private let disposeBag = DisposeBag()
    
    private let chatHeaderView = ChatHeaderView().then {
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.borderWidth = 1.0 / UIScreen.main.scale
    }
    private lazy var messageViewController = MessageViewController(viewModel: viewModel)
    
    // MARK: - Lifecycles
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
        bind()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.channelInfo.withUserName
    }

    
    private func configureUI() {
        addChild(messageViewController)
        view.addSubviews(
            chatHeaderView,
            messageViewController.view
        )
        messageViewController.didMove(toParent: self)
        
        chatHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        messageViewController.view.snp.makeConstraints {
            $0.top.equalTo(chatHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.recruit
            .withUnretained(self)
            .subscribe { (owner, recruit) in
                guard let recruit = recruit else { return }
                owner.chatHeaderView.configureInfo(recruit: recruit)
            }
            .disposed(by: disposeBag)
    }
}
