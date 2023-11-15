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

extension ChatViewController: MessagesDataSource {
    var currentSender: SenderType {
        // TODO: - ViewModel 완성 후 ! 지우기
        return Sender(senderId: viewModel.currentUser!.id, displayName: viewModel.currentUser!.userName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messages.count
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
