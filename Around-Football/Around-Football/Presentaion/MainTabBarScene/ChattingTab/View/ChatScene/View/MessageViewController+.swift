//
//  MessageViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 12/18/23.
//

import UIKit

extension MessageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return imageTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
}

extension MessageViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // UIResponder.keyboardWillShowNotification : 키보드가 해제되기 직전에 post 된다.
        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboardShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification , object: nil)
    }
    
    // 키보드 업
    @objc
    func setKeyboardShow(_ notification: Notification) {
        messagesCollectionView.scrollToLastItem(animated: true)
    }
}
