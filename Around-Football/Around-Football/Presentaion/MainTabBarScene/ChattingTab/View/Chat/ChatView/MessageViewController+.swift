//
//  MessageViewController+.swift
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
    func bindEnabledCameraBarButton() {
        viewModel.isSendingPhoto
            .withUnretained(self)
            .subscribe { (owner, isSendingPhoto) in
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
                owner.messageViewController.messageInputBar.leftStackViewItems.forEach {
                    guard let item = $0 as? InputBarButtonItem,
                          let channel = channel else { return }
                    DispatchQueue.main.async {
                        item.isEnabled = channel.isAvailable
                        owner.messageViewController.messageInputBar.isHidden = !channel.isAvailable
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
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if (message as? Message)?.image != nil {
            return .white
        }
        
        return isFromCurrentSender(message: message) ? .primary : .incomingMessageBackground
    }
    
    func textColor(for message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
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

    // 말풍선 측면에 발송 시각 표시
    func messageBottomLabelAttributedText(for message: MessageType,
                                          at indexPath: IndexPath) -> NSAttributedString? {
        guard let message = message as? Message else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        let dateString = dateFormatter.string(from: message.sentDate)
        
        let isShowingTimeLabel = message.showTimeLabel
        
        return isShowingTimeLabel ? NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]) : nil
    }
    
    // 말풍선 측면 발송 시각 레이블 Height
    func messageBottomLabelHeight(for message: MessageType,
                                  at indexPath: IndexPath,
                                  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard let message = message as? Message else { return 16 }
        let isShowingTimeLabel = message.showTimeLabel

        return isShowingTimeLabel ? 16 : 0
    }
    
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        let leftInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let rightInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return isFromCurrentSender(message: message) ? .some(.init(textAlignment: .right, textInsets: rightInset)) : .some(.init(textAlignment: .left, textInsets: leftInset))
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
        print(#function)
        print("didTapMessage")
        guard let indexPath = messageViewController.messagesCollectionView.indexPath(for: cell),
              let messagesDataSource = messageViewController.messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messageViewController.messagesCollectionView)
        switch message.kind {
        case .photo(let photoItem):
            print("DEBUG - Message in a photo")
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

extension MessageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return imageTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DisMissAnim()
    }
}
