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
    
    // 지역 입력 텍스트필드 선택 시 뷰 이동 (위로 올림)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputInfoView.userAreaTextField {
            UIView.animate(withDuration: 0.3) {
                let transform = CGAffineTransform(translationX: 0, y: -200)
                self.view.transform = transform
            }
        }
    }
    
    // 뷰 다시 원위치
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == inputInfoView.userAreaTextField {
            UIView.animate(withDuration: 0.3) {
                let transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.transform = transform
            }
        }
    }
    
    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

