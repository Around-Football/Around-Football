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
    func bindEnabledCameraBarButton() {
        viewModel.isSendingPhoto
            .withUnretained(self)
            .subscribe { (owner, isSendingPhoto) in
                owner.messageInputBar.leftStackViewItems.forEach {
                    guard let item = $0 as? InputBarButtonItem else { return }
                    DispatchQueue.main.async {
                        item.isEnabled = !isSendingPhoto
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindCameraBarButtonEvent() {
        cameraBarButtonItem.rx.tap
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
                    owner.messagesCollectionView.reloadData()
                    if owner.viewModel.messages.value.count > 0 {
                        owner.messagesCollectionView.scrollToLastItem(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func sendWithText(buttonEvent: ControlEvent<Void>) -> Observable<String> {
        return buttonEvent
            .withLatestFrom(messageInputBar.inputTextView.rx.text.orEmpty)
            .do(onNext: { [weak self] _ in
                self?.messageInputBar.inputTextView.text.removeAll()
            })
            .asObservable()
    }
}

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return viewModel.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages.value[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messages.value.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                             .foregroundColor: UIColor(white: 0.3, alpha: 1)
        ])
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    // 아래 여백
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return CGFloat(10)
    }
    
    // 말풍선 위 이름 나오는 곳의 Height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessageBackground
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
    
    // 말풍선 측면에 발송 시각 표시
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
    }
    
    // 말풍선 측면 발송 시각 레이블 Height
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
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
    
    //    private func sendPhoto(_ image: UIImage) {
    //        // TODO: - 첫 메시지인경우 채팅방 생성 로직 추가
    //        // TODO: - ViewModel 완성 후 아래 로직 전면 재교체 (강제 언래핑, Rx적용)
    //        isSendingPhoto = true
    //        StorageAPI.uploadImage(image: image, channel: viewModel.channel.value) { [weak self] url in
    //            guard let self = self, let url = url else { return }
    //            self.isSendingPhoto = false
    //            var message = Message(user: viewModel.currentUser!, image: image)
    //            message.downloadURL = url
    //            self.viewModel.chatAPI.save(message)
    //            self.messagesCollectionView.scrollToLastItem(animated: false)
    //            self.viewModel.channelAPI.updateChannelInfo(owner: viewModel.currentUser!, withUser: viewModel.withUser!, channelId: viewModel.channel.id, message: message)
    //
    //        }
    //    }
    
    func imagePickerControllerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        inputBar.inputTextView.text.removeAll()
    }
}

// MARK: - ImageCell Custom DetailView

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        print(#function)
        print("didTapMessage")
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .photo(let photoItem):
            print("DEBUG - Message in a photo")
            if let image = photoItem.image {
                // cell의 위치정보
                let cellOriginFrame = cell.superview?.convert(cell.frame, to: nil)
                let cellOriginPoint = cellOriginFrame?.origin
                
                
                // Transition 설정
                imageTransition.setPoint(point: cellOriginPoint)
                imageTransition.setFrame(frame: cellOriginFrame)
                
                let imageMessageViewController = ImageMessageViewController()
                imageMessageViewController.image = image
                imageMessageViewController.transitioningDelegate = self
                imageMessageViewController.modalPresentationStyle = .custom
                
                present(imageMessageViewController, animated: true)
            }
        default:
            print("DEBUG - Message is not a photo")
            break
        }
    }
}

extension ChatViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return imageTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DisMissAnim()
    }
}
