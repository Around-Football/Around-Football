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

final class ChatViewController: UIViewController {
    
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
    
    lazy var containerView = UIView().then {
        $0.frame = view.bounds
    }
    
    private lazy var navigationRightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(tappedNavigationRightBarButton)
        )
        barButton.tintColor = AFColor.grayScale200
        return barButton
    }()
    
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
        configureUI()
        configureDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetAlarmInformation()
        invokedViewWillAppear.onNext(())
        self.navigationItem.largeTitleDisplayMode = .never // This fixes the issue
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.secondary
        ]
        navigationController?.navigationBar.tintColor = AFColor.secondary
        NotiManager.shared.currentChatRoomId = nil
        viewModel.removeListener()
    }
    
    // MARK: - Helpers
    
    private func configureDelegate() {
        messageViewController.messagesCollectionView.messagesDataSource = self
        messageViewController.messagesCollectionView.messagesLayoutDelegate = self
        messageViewController.messagesCollectionView.messagesDisplayDelegate = self
        messageViewController.messagesCollectionView.messageCellDelegate = self
        messageViewController.messagesCollectionView.register(CustomInfoMessageCell.self,
                                                              forCellWithReuseIdentifier: CustomInfoMessageCell.cellId)
    }
    
    @objc
    private func tappedNavigationRightBarButton() {
        let actionSheet = UIAlertController(
            title: nil,
            message: "내부 검토 후  24시간 이내 해당 유저의 이용제한 절차가 진행됩니다. 허위 신고 시 서비스 이용제한 등의 불이익을 받을 수 있으니 주의해 주세요.",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "신고하기",
                style: .destructive,
                handler: { [weak self] _ in
                    self?.sendEmail(
                        message: """
신고 유저: \(self?.viewModel.fetchReportUser() ?? "직접 입력")\n
신고 사유:\n
신고 내용:
"""
                    )
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = navigationRightBarButton
        view.backgroundColor = .systemBackground
        addChild(messageViewController)
        view.addSubviews(
            imageLoadingView,
            chatHeaderView,
            containerView
        )
        containerView.addSubview(messageViewController.view)
        
        messageViewController.didMove(toParent: self)
        
        chatHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        containerView.snp.makeConstraints {
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
        bindNavigationTitle()
        
        // MARK: - Bind MessageViewController
        bindCameraBarButtonEvent()
        bindMessages()
        bindEnabledCameraBarButton()
        bindEnabledSendObjectButton()
    }
}
