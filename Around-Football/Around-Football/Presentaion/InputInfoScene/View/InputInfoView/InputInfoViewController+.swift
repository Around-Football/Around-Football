//
//  InputInfoViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

extension InputInfoViewController: UITextFieldDelegate {
    //텍스트필드 변경할때마다 변수로 수정하고 갱신
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userName = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        viewModel?.userName.accept(userName)
        viewModel?.updateData()
        
        return true
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

