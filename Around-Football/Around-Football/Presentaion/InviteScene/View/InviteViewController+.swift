//
//  InviteViewController+.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/3/23.
//

import UIKit

// MARK: - 키보드 관련 함수

extension InviteViewController {
    @objc 
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    @objc 
    func keyboardWillHide(_ notification: Notification) {
        self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TextViewDelegate

extension InviteViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard ((textField.text as NSString?)?.replacingCharacters(in: range, with: string)) != nil else { return true }

//        if text.isEmpty {
//            titlePlaceHolderLabel.isHidden = false
//            viewModel.contentTitle.accept(nil)
//        } else {
//            titlePlaceHolderLabel.isHidden = true
//            viewModel.contentTitle.accept(text)
//        }
        
        return true
    }
}

extension InviteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            contentPlaceHolderLabel.isHidden = false
            viewModel.content.accept("")
        } else {
            contentPlaceHolderLabel.isHidden = true
            viewModel.content.accept(textView.text)
        }
    }
}
