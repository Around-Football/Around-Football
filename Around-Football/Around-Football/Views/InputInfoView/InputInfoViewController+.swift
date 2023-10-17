//
//  InputInfoViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

extension InputInfoViewController: UITextFieldDelegate {
    // 엔터 누르면 다음 텍스트필드로 넘어감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputInfoView.userNameTextField {
            inputInfoView.userAgeTextField.becomeFirstResponder()
        } else if textField == inputInfoView.userAgeTextField {
            inputInfoView.userContactTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
