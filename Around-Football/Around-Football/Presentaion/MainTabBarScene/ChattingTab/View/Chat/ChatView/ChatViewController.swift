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
    let tapGesture = UITapGestureRecognizer()
    
    // View
    lazy var chatHeaderView = ChatHeaderView().then {
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.borderWidth = 1.0 / UIScreen.main.scale
        $0.addGestureRecognizer(tapGesture)
    }
    let messageViewController = MessageViewController()
    
    lazy var imageLoadingView = UIActivityIndicatorView(style: .large).then {
        $0.center = view.center
    }
    
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
    
    deinit {
        viewModel.removeListener()
        
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
            imageLoadingView,
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
            $0.top.equalTo(chatHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        imageLoadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.bringSubviewToFront(imageLoadingView)
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
        
        // MARK: - Bind MessageViewController
        bindCameraBarButtonEvent()
        bindMessages()
        bindEnabledCameraBarButton()
        bindEnabledSendObjectButton()
    }
}
