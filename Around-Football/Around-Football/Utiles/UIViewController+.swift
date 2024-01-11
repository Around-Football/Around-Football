//
//  UIViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 12/22/23.
//

import UIKit

extension UIViewController {
    func showPopUp(title: String? = nil,
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    func showPopUp(contentView: UIView,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(contentView: contentView)
        
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    private func showPopUp(popUpViewController: PopUpViewController,
                           leftActionTitle: String,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: leftActionTitle,
                                              titleColor: AFColor.grayScale300,
                                              backgroundColor: AFColor.grayScale50) {
            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        }
        
        popUpViewController.addActionToButton(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: AFColor.secondary) {
            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
}

// MARK: - BackButton

extension UIViewController {
    func setAFBackButton() {
        let AFBackButton = UIBarButtonItem(image: UIImage(named: AFIcon.backButton), style: .plain, target: self, action: #selector(popViewController))
        AFBackButton.tintColor = AFColor.grayScale200
        self.navigationItem.setLeftBarButton(AFBackButton, animated: true)
    }
    
    @objc
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func setModalAFBackButton() {
        let AFBackButton = UIBarButtonItem(image: UIImage(named: AFIcon.backButton), style: .plain, target: self, action: #selector(dismissViewController))
        AFBackButton.tintColor = AFColor.grayScale200
        self.navigationItem.setLeftBarButton(AFBackButton, animated: true)
    }
    
    @objc
    func dismissViewController() {
        dismiss(animated: true)
    }
}
