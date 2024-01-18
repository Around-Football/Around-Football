//
//  InputInfoViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

extension InputInfoViewController: UITextFieldDelegate {
    
    // MARK: - 한글 마지막 자모 분리로 delegate함수 수정
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.userName.accept(textField.text!)
        viewModel?.updateData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func keyboardController() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

