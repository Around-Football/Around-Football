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
import RxCocoa

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: ChatViewModel
    private let tapGesture = UITapGestureRecognizer()
    
    // View
    private lazy var chatHeaderView = ChatHeaderView().then {
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.borderWidth = 1.0 / UIScreen.main.scale
        $0.addGestureRecognizer(tapGesture)
    }
    let messageViewController = MessageViewController()
    
    // Rx
    let disposeBag = DisposeBag()
    private let invokedViewWillAppear = PublishSubject<Void>()
    let pickedImage = PublishSubject<UIImage>()
    
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
        configureDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance()
        viewModel.resetAlarmInformation()
        invokedViewWillAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeListener()
        NotiManager.shared.currentChatRoomId = nil
        
        //딥링크 네비게이션으로 왔을때만 네비게이션바 없애줌
        if viewModel.coordinator as? DeepLinkCoordinator != nil {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.channelInfo.withUserName
    }
    
    private func configureDelegate() {
        messageViewController.messagesCollectionView.messagesDataSource = self
        messageViewController.messagesCollectionView.messagesLayoutDelegate = self
        messageViewController.messagesCollectionView.messagesDisplayDelegate = self
        messageViewController.messagesCollectionView.messageCellDelegate = self
        messageViewController.messagesCollectionView.register(CustomInfoMessageCell.self,
                                                              forCellWithReuseIdentifier: CustomInfoMessageCell.cellId)
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
        
        let didTapSendButton = sendWithText(buttonEvent: messageViewController.messageInputBar.sendButton.rx.tap)
        let input = ChatViewModel.Input(didTapSendButton: didTapSendButton,
                                        pickedImage: pickedImage,
                                        invokedViewWillAppear: invokedViewWillAppear)
        let output = viewModel.transform(input)
        // MARK: - Bind HeaderView
        bindRecruitInfo(by: output.recruitStatus)
        bindRecruitInfoTapEvent()
        
        bindCameraBarButtonEvent()
        bindMessages()
        bindEnabledCameraBarButton()
        bindEnabledSendObjectButton()
    }
    
    private func bindRecruitInfo(by observe: Observable<Recruit>) {
        observe
            .withUnretained(self)
            .subscribe(onNext: { (owner, recruit) in
                owner.chatHeaderView.configureInfo(recruit: recruit)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRecruitInfoTapEvent() {
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.viewModel.showDetailRecruitView()
            }
            .disposed(by: disposeBag)
    }
}
