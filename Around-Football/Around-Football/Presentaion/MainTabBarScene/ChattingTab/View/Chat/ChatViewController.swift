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

final class ChatViewController: MessagesViewController {
    
    // MARK: - Properties
    
    var viewModel: ChatViewModel
    
    // ImageTransition 인스턴스 생성
    let imageTransition = ImageTransition()
    
    var isSendingPhoto = false {
        didSet {
            messageInputBar.leftStackViewItems.forEach {
                guard let item = $0 as? InputBarButtonItem else { return }
                DispatchQueue.main.async {
                    item.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    lazy var cameraBarButtonItem = InputBarButtonItem(type: .system).then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "camera")
        // TODO: - RxCocoa Binding
//        $0.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
    }

    // MARK: - Lifecycles
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
        configureDelegate()
        setupMessageInputBar()
        removeOutgoingMessageAvatars()
        addCameraBarButtonToMessageInputBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: - NotiManager.shared.currentChatRoomId = channel.id
        //                 self?.channelAPI.resetAlarmNumber(uid: self!.user.uid, channelId: id)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: - NotiManager.shared.currentChatRoomId = nil
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
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

    
}
