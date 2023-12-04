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
                print(#function)
                self?.messageInputBar.inputTextView.text.removeAll()
            })
            .asObservable()
    }
    
//    func updateShowTimeLabel() {
//        var messages: [Message] = viewModel.messages.value
//        for i in 0..<messages.count {
//            var message = messages[i]
//            let previousMessage: Message? = i > 0 ? messages[i - 1] : nil
//            if let previousMessage = previousMessage,
//                Calendar.current.isDate(message.sentDate, equalTo: previousMessage.sentDate, toGranularity: .minute)
//                && message.sender.senderId == previousMessage.sender.senderId {
//                message.showTimeLabel = false
//            } else {
//                message.showTimeLabel = true
//            }
//        }
//        viewModel.messages.accept(messages)
//    }
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
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
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
        return .bubble
    }
    
    // 말풍선 측면에 발송 시각 표시
    func messageBottomLabelAttributedText(for message: MessageType,
                                          at indexPath: IndexPath) -> NSAttributedString? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: message.sentDate)
        
        let isShowingTimeLabel = viewModel.messages.value[indexPath.row].showTimeLabel
        
        print(indexPath.item, isShowingTimeLabel)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
//        return isConfigureTimeLabel(at: indexPath) ? NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]) : nil
    }
    
    // 말풍선 측면 발송 시각 레이블 Height
    func messageBottomLabelHeight(for message: MessageType,
                                  at indexPath: IndexPath,
                                  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
//    func isConfigureTimeLabel(at indexPath: IndexPath) -> Bool {
//        let message = viewModel.messages.value[indexPath.section]
//        let previousMessage: Message? = indexPath.section > 0 ? viewModel.messages.value[indexPath.section - 1] : nil
//
//        if let previousMessage = previousMessage,
//            Calendar.current.isDate(message.sentDate, equalTo: previousMessage.sentDate, toGranularity: .minute),
//           message.sender.senderId == previousMessage.sender.senderId {
//            return false
//        } else {
//            return true
//        }
//    }

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
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return imageTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DisMissAnim()
    }
}
