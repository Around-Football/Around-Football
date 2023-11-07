//
//  InputInfoViewController.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

protocol InputInfoViewControllerDelegate: AnyObject {
    func dismissModalView()
}

final class InputInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: InputInfoViewControllerDelegate?
    let inputInfoView: InputInfoView = InputInfoView()
    
    // MARK: - Lifecycles
    
    override func loadView() {
        self.view = inputInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardController()
        
        inputInfoView.userNameTextField.delegate = self
        inputInfoView.userAgeTextField.delegate = self
        inputInfoView.userContactTextField.delegate = self
        inputInfoView.userAreaTextField.delegate = self
        
        inputInfoView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        inputInfoView.maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        inputInfoView.femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        
        inputInfoView.rightFootButton.addTarget(self, action: #selector(rightFootButtonTapped), for: .touchUpInside)
        inputInfoView.leftFootButton.addTarget(self, action: #selector(leftFootButtonTapped), for: .touchUpInside)
        inputInfoView.bothFeetButton.addTarget(self, action: #selector(bothFeetButtonTapped), for: .touchUpInside)
        
        inputInfoView.fwButton.addTarget(self, action: #selector(fwButtonTapped), for: .touchUpInside)
        inputInfoView.mfButton.addTarget(self, action: #selector(mfButtonTapped), for: .touchUpInside)
        inputInfoView.dfButton.addTarget(self, action: #selector(dfButtonTapped), for: .touchUpInside)
        inputInfoView.gkButton.addTarget(self, action: #selector(gkButtonTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        navigationItem.title = "추가정보 입력"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    
    @objc 
    func nextButtonTapped(_ sender: UIButton) {
        print("DEBUG: InputInfoViewController - nextButtonTapped")
        delegate?.dismissModalView()
    }
    
    @objc 
    func maleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.femaleButton.isSelected {
            inputInfoView.femaleButton.isSelected.toggle()
        }
    }
    
    @objc 
    func femaleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.maleButton.isSelected {
            inputInfoView.maleButton.isSelected.toggle()
        }
    }
    
    @objc 
    func rightFootButtonTapped(_ sender: UIButton) {
        if inputInfoView.leftFootButton.isSelected {
            inputInfoView.leftFootButton.isSelected.toggle()
        }
        if inputInfoView.bothFeetButton.isSelected {
            inputInfoView.bothFeetButton.isSelected.toggle()
        }
        sender.isSelected.toggle()
    }
    
    @objc 
    func leftFootButtonTapped(_ sender: UIButton) {
        if inputInfoView.rightFootButton.isSelected {
            inputInfoView.rightFootButton.isSelected.toggle()
        }
        if inputInfoView.bothFeetButton.isSelected {
            inputInfoView.bothFeetButton.isSelected.toggle()
        }
        sender.isSelected.toggle()
    }
    
    @objc 
    func bothFeetButtonTapped(_ sender: UIButton) {
        if inputInfoView.rightFootButton.isSelected {
            inputInfoView.rightFootButton.isSelected.toggle()
        }
        if inputInfoView.leftFootButton.isSelected {
            inputInfoView.leftFootButton.isSelected.toggle()
        }
        sender.isSelected.toggle()
    }
    
    @objc 
    func fwButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc 
    func mfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc 
    func dfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc 
    func gkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    //TODO: - Keyboard 함수 Utiles로 정리
    private func keyboardController() {
        //화면 탭해서 키보드 내리기
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
