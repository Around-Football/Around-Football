//
//  MessageViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

import SnapKit
import MessageKit
import InputBarAccessoryView
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa


final class MessageViewController: MessagesViewController {
    
    // MARK: - Properties
    
    let imageTransition = ImageTransition()

    lazy var cameraBarButtonItem = InputBarButtonItem(type: .system).then {
        $0.tintColor = AFColor.grayScale200
        $0.image = UIImage(named: "Camera")
        $0.setSize(CGSize(width: 32, height: 32), animated: false)
        
    }
    
    // MARK: - Lifecycles
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupMessageInputBar()
        setupMessageInputBarLayer()
        removeOutgoingMessageAvatars()
        addCameraBarButtonToMessageInputBar()
        setSendBarButtonToMessageInputBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground

        if let sendButton = messageInputBar.rightStackView.arrangedSubviews.first as? InputBarButtonItem {
            let containerView = UIView()
            messageInputBar.rightStackView.addArrangedSubview(containerView)
            containerView.addSubview(sendButton)
            sendButton.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-5)
            }
        }
        messageInputBar.middleContentView?.snp.makeConstraints {
            $0.top.equalTo((messageInputBar.inputTextView.inputBarAccessoryView?.snp.top)!).offset(16)
        }
    }
        
    private func setupMessageInputBar() {
        messageInputBar.inputTextView.placeholderLabel.attributedText = NSAttributedString(string: "채팅 보내기",
                                                                                           attributes: [.font: AFFont.text as Any,
                                                                                                        .foregroundColor: AFColor.grayScale200])
        messageInputBar.inputTextView.backgroundColor = AFColor.grayMessage
        messageInputBar.inputTextView.layer.cornerRadius = 16
        messageInputBar.inputTextView.font = AFFont.text
        messageInputBar.inputTextView.textColor = AFColor.secondary
        messageInputBar.inputTextView.textContainerInset = .init(top: 10, left: 16, bottom: 10, right: 16)
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
    
    private func setSendBarButtonToMessageInputBar() {
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.setSize(CGSize(width: 32, height: 32), animated: false)
        messageInputBar.sendButton.setImage(UIImage(named: "Send_Disabled"), for: .disabled)
        messageInputBar.sendButton.setImage(UIImage(named: "Send_Enabled"), for: .normal)
    }
    
    private func setupMessageInputBarLayer() {
        messageInputBar.inputTextView.inputBarAccessoryView?.separatorLine.backgroundColor = UIColor.clear
        messageInputBar.inputTextView.inputBarAccessoryView?.layer.shadowOffset = CGSize(width: 0, height: -0.4)
        messageInputBar.inputTextView.inputBarAccessoryView?.layer.shadowOpacity = 1
        messageInputBar.inputTextView.inputBarAccessoryView?.layer.shadowColor = AFColor.grayScale50.cgColor
        messageInputBar.inputTextView.inputBarAccessoryView?.layer.shadowRadius = 0
    }
}
