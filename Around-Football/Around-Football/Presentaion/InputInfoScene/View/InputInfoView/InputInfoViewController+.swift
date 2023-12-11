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
        switch textField {
        case inputInfoView.userNameTextField:
            let userName = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            viewModel?.userName.accept(userName)
            viewModel?.updateData()
        case inputInfoView.userAgeTextField:
            let age = Int((textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? "")
            viewModel?.age.accept(age)
            viewModel?.updateData()
//        case inputInfoView.userAreaTextField:
//            area = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//            inputData["area"] = area
        default:
            return true
        }

        return true
    }
    
    // 엔터 누르면 다음 텍스트필드로 넘어감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputInfoView.userNameTextField {
            inputInfoView.userAgeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //화면 누르면 키보드 내려감
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    // 지역 입력 텍스트필드 선택 시 뷰 이동 (위로 올림)
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == inputInfoView.userAreaTextField {
//            UIView.animate(withDuration: 0.3) {
//                let transform = CGAffineTransform(translationX: 0, y: -200)
//                self.view.transform = transform
//            }
//        }
//    }
    
//    // 뷰 다시 원위치
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == inputInfoView.userAreaTextField {
//            UIView.animate(withDuration: 0.3) {
//                let transform = CGAffineTransform(translationX: 0, y: 0)
//                self.view.transform = transform
//            }
//        }
//    }
}

