//
//  TextFieldDelegateHandler.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import UIKit

class TextFieldDelegateHandler: NSObject, UITextFieldDelegate {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TextField가 편집 모드에 들어갈 때 화면을 위로 이동
        UIView.animate(withDuration: 0.3, animations: {
            if let viewController = self.viewController {
                viewController.view.frame = CGRect(x: viewController.view.frame.origin.x, y: viewController.view.frame.origin.y - 200, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            }
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TextField에서 편집이 끝날 때 화면을 원래 위치로 이동
        UIView.animate(withDuration: 0.3, animations: {
            if let viewController = self.viewController {
                viewController.view.frame = CGRect(x: viewController.view.frame.origin.x, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            }
        })
    }
    
    // FIXME: - SignUpViewController 작동 X
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Return 키를 누를 때 다음 TextField로 포커스 이동
        if let viewController = self.viewController as? LoginViewController {
            if textField == viewController.emailTextField {
                viewController.passwordTextField.becomeFirstResponder()
            } else if textField == viewController.passwordTextField {
                viewController.passwordTextField.resignFirstResponder()
            }
        }
        return true
    }
}
