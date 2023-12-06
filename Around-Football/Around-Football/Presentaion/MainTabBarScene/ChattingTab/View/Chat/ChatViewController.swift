//
//  ChatViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

import MessageKit
import InputBarAccessoryView
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa


final class ChatViewController: MessagesViewController {
    // MARK: - Properties
    
    var viewModel: ChatViewModel
    
    let imageTransition = ImageTransition()
    let disposeBag = DisposeBag()
    let pickedImage = PublishSubject<UIImage>()
    private let invokedViewWillAppear = PublishSubject<Void>()
    private let invokedViewWillDisappear = PublishSubject<Void>()
    
    lazy var cameraBarButtonItem = InputBarButtonItem(type: .system).then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "camera")
    }
    
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
        configureDelegate()
        setupMessageInputBar()
        removeOutgoingMessageAvatars()
        addCameraBarButtonToMessageInputBar()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance()
        invokedViewWillAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        invokedViewWillDisappear.onNext(())
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.channelInfo.withUserName
    }
    
    private func configureDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.register(CustomInfoMessageCell.self,
                                        forCellWithReuseIdentifier: CustomInfoMessageCell.cellId)
    }
    
    private func setupMessageInputBar() {
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
        messageInputBar.inputTextView.placeholder = "Input Message"
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout
                as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(
            textAlignment: .right,
            textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        )
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addCameraBarButtonToMessageInputBar() {
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    }
    
    private func bind() {
        let didTapSendButton = sendWithText(buttonEvent: messageInputBar.sendButton.rx.tap)
        let input = ChatViewModel.Input(didTapSendButton: didTapSendButton,
                                        pickedImage: pickedImage,
                                        invokedViewWillAppear: invokedViewWillAppear,
                                        invokedViewWillDisappear: invokedViewWillDisappear)
        _ = viewModel.transform(input)
        bindCameraBarButtonEvent()
        bindMessages()
        bindEnabledCameraBarButton()
    }
}
