//
//  ChatViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 11/15/23.
//

import UIKit
import PhotosUI

import MessageKit
import InputBarAccessoryView
import RxSwift
import RxCocoa

// MARK: - Binding

extension ChatViewController {
        
    func bindRecruitInfo(by observe: Observable<Recruit?>) {
        observe
            .withUnretained(self)
            .subscribe(onNext: { (owner, recruit) in
                owner.chatHeaderView.configureInfo(recruit: recruit)
            }) // onError가 발생한 경우 Error 뷰 나타내기(네트워크 환경 등)
            .disposed(by: disposeBag)
    }
    
    func bindRecruitInfoTapEvent() {
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.viewModel.showDetailRecruitView()
            }
            .disposed(by: disposeBag)
    }

    func bindEnabledCameraBarButton() {
        viewModel.isSendingPhoto
            .withUnretained(self)
            .subscribe { (owner, isSendingPhoto) in
                DispatchQueue.main.async {
                    if isSendingPhoto {
                        owner.imageLoadingView.startAnimating()
                        owner.imageLoadingView.isHidden = false
                    } else {
                        owner.imageLoadingView.stopAnimating()
                        owner.imageLoadingView.isHidden = true
                    }
                }
                
                owner.messageViewController.messageInputBar.leftStackViewItems.forEach {
                    guard let item = $0 as? InputBarButtonItem else { return }
                    DispatchQueue.main.async {
                        item.isEnabled = !isSendingPhoto
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindCameraBarButtonEvent() {
        messageViewController.cameraBarButtonItem.rx.tap
            .withUnretained(self)
            .subscribe { (owner, event) in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 1
                configuration.filter = .images
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                
                owner.viewModel.showPHPickerView(picker: picker)
            }
            .disposed(by: disposeBag)
    }
    
    func bindMessages() {
        viewModel.messages
            .withUnretained(self)
            .subscribe { (owner, messages) in
                DispatchQueue.main.async {
                    owner.messageViewController.messagesCollectionView.reloadData()
                    if owner.viewModel.messages.value.count > 0 {
                        owner.messageViewController.messagesCollectionView.scrollToLastItem(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func sendWithText(buttonEvent: ControlEvent<Void>) -> Observable<String> {
        return buttonEvent
            .withLatestFrom(messageViewController.messageInputBar.inputTextView.rx.text.orEmpty)
            .do(onNext: { [weak self] _ in
                print(#function)
                self?.messageViewController.messageInputBar.inputTextView.text.removeAll()
            })
            .asObservable()
    }
    
    func bindEnabledSendObjectButton() {
        viewModel.channel
            .withUnretained(self)
            .subscribe { (owner, channel) in
                guard let channel = channel else { return }
                if !channel.isAvailable {
                    DispatchQueue.main.async {
                        owner.messageViewController.messageInputBar.isUserInteractionEnabled = false
                        owner.messageViewController.messageInputBar.inputTextView.placeholder = "채팅을 보낼 수 없습니다."
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return viewModel.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages.value[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messages.value.count
    }
        
    func messageTopLabelAttributedText(for message: MessageType,
                                       at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name,
                                  attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                               .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        guard let message = message as? Message else { return UICollectionViewCell() }
        guard let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: CustomInfoMessageCell.cellId, 
                                                                    for: indexPath) as? CustomInfoMessageCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = message.content
        cell.updateCustomInfoLabelUI()
        return cell
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    // 아래 여백
    func cellBottomLabelHeight(for message: MessageType,
                               at indexPath: IndexPath,
                               in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return CGFloat(10)
    }
    
    // 말풍선 위 이름 나오는 곳의 Height
    func messageTopLabelHeight(for message: MessageType,
                               at indexPath: IndexPath,
                               in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return .zero
    }
    
    func avatarSize(for message: MessageType,
                    at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return CGSize.zero
    }
    
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        return CustomInfoMessageCellSizeLayout(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
    }
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatViewController: MessagesDisplayDelegate {
    
    // 메시지 측면, 발송 시각 View
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else { return }
        let sentDateLabel = UILabel().then {
            $0.font = AFFont.filterDay
            $0.textColor = AFColor.grayScale200
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        let dateString = dateFormatter.string(from: message.sentDate)
        
        let isShowingTimeLabel = message.showTimeLabel
        let sentDateString = isShowingTimeLabel ? dateString : ""
        sentDateLabel.text = sentDateString
        accessoryView.subviews.forEach { $0.removeFromSuperview() }

        accessoryView.addSubview(sentDateLabel)
        sentDateLabel.frame = accessoryView.bounds
        accessoryView.backgroundColor = .systemBackground
    }
    
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if (message as? Message)?.image != nil {
            return .white
        }
        
        return isFromCurrentSender(message: message) ? AFColor.primaryMessage : AFColor.grayMessage
    }
    
    func textColor(for message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return AFColor.secondary
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard let message = message as? Message else { return .bubble }
        switch message.messageType {
        case .chat: return .bubble
        default: return .none
        }
    }
}

extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    self?.pickedImage.onNext(image)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - ImageCell Custom DetailView

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messageViewController.messagesCollectionView.indexPath(for: cell),
              let messagesDataSource = messageViewController.messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messageViewController.messagesCollectionView)
        switch message.kind {
        case .photo(let photoItem):
            if let image = photoItem.image {
                // cell의 위치정보
                let cellOriginFrame = cell.superview?.convert(cell.frame, to: nil)
                let cellOriginPoint = cellOriginFrame?.origin
                
                
                // Transition 설정
                messageViewController.imageTransition.setPoint(point: cellOriginPoint)
                messageViewController.imageTransition.setFrame(frame: cellOriginFrame)
                
                let imageMessageViewController = ImageMessageViewController()
                imageMessageViewController.image = image
                imageMessageViewController.transitioningDelegate = self.messageViewController
                imageMessageViewController.modalPresentationStyle = .custom
                
                present(imageMessageViewController, animated: true)
            }
        default:
            print("DEBUG - Message is not a photo")
            break
        }
    }
}
