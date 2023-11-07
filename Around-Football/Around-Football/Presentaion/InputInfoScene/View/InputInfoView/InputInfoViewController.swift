//
//  InputInfoViewController.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

protocol InputInfoViewControllerDelegate: AnyObject {
    func dismissView()
    func removeThisChildCoordinators()
}

final class InputInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: InputInfoViewControllerDelegate?
    let inputInfoView: InputInfoView = InputInfoView()
    
    private var id: String = ""
    private var userName: String = ""
    private var age: Int = 0
    private var contact: Int = 0
    private var detailSex: String = ""
    private var area: String = ""
    private var mainUsedFeet: String = ""
    private var position: String = ""
    
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
        navigationItem.title = "추가정보 입력"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.removeThisChildCoordinators()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    
    @objc 
    func nextButtonTapped(_ sender: UIButton) {
        print("DEBUG: InputInfoViewController - nextButtonTapped")

        delegate?.dismissView()

        area = inputInfoView.userAreaTextField.text ?? ""
        userName = inputInfoView.userNameTextField.text ?? ""
        age = Int(inputInfoView.userAgeTextField.text ?? "") ?? 0
      
        FirebaseAPI.shared.updateUser(User(dictionary: ["userName" : userName,
                                                        "age" : age,
                                                        "contact" : contact,
                                                        "detailSex" : detailSex,
                                                        "area" : area,
                                                        "mainUsedFeet" : mainUsedFeet,
                                                        "position" : position
                                                       ]))
    }
    
    @objc 
    func maleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.femaleButton.isSelected {
            inputInfoView.femaleButton.isSelected.toggle()
        }
        detailSex = sender.titleLabel?.text ?? ""
    }
    
    @objc 
    func femaleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.maleButton.isSelected {
            inputInfoView.maleButton.isSelected.toggle()
        }
        detailSex = sender.titleLabel?.text ?? ""
        
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
        mainUsedFeet = sender.titleLabel?.text ?? ""
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
        mainUsedFeet = sender.titleLabel?.text ?? ""
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
        mainUsedFeet = sender.titleLabel?.text ?? ""
    }
    
    @objc 
    func fwButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        position = sender.titleLabel?.text ?? ""
    }
    
    @objc 
    func mfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        position = sender.titleLabel?.text ?? ""
    }
    
    @objc 
    func dfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        position = sender.titleLabel?.text ?? ""
    }
    
    @objc 
    func gkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        position = sender.titleLabel?.text ?? ""
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
