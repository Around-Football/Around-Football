//
//  UIViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 12/22/23.
//

import UIKit
import MessageUI

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
        dismiss(animated: false)
    }
}

// MARK: - Action Sheet

extension UIViewController {
    func alertActionSheet(title: String? = nil, message: AlertMessage, actions: [UIAlertAction]) {
        let actionSheet = UIAlertController(
            title: title,
            message: message.description,
            preferredStyle: .actionSheet
        )
        for action in actions {
            actionSheet.addAction(action)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - MessageUI 이메일

extension UIViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(message: AlertMessage? = nil) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["aroundfootball2024@gmail.com"]) // 수신자 이메일 주소
            mailController.setSubject("[어라운드풋볼 1:1문의]") // 이메일 제목
            guard let message else {
                present(mailController, animated: true, completion: nil)
                return
            }
            mailController.setMessageBody(message.description, isHTML: false) // 이메일 내용
            
            present(mailController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "메일 전송 실패",
            message: "이메일 설정을 확인하고 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in print("확인") }
        sendMailErrorAlert.addAction(confirmAction)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("이메일 보내기 취소")
        case .sent:
            print("이메일 보내기 성공")
        case .saved:
            print("이메일이 저장되었습니다.")
        case .failed:
            print("이메일 보내기 실패")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
