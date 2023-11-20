//
//  InputInfoViewController.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

import RxCocoa
import RxSwift

//TODO: - 기존에 유저 정보 있으면 로딩시 텍스트필드에 넣어주기

final class InputInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: InputInfoViewModel?
    let inputInfoView: InputInfoView = InputInfoView()
    
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    private var id: String? = ""
    private lazy var userName: String? = inputInfoView.userNameTextField.text
    private lazy var age: Int? = Int(inputInfoView.userAgeTextField.text ?? "")
    private var gender: String? = ""
    private lazy var area: String? = inputInfoView.userAreaTextField.text
    private var mainUsedFeet: String? = ""
    private var position: String? = ""
    
    // MARK: - Lifecycles
    
    init(viewModel: InputInfoViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = inputInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        isInfoCompleted()
        bindUI()
        navigationItem.title = "추가정보 입력"
        keyboardController()

        inputInfoView.userNameTextField.delegate = self
        inputInfoView.userAgeTextField.delegate = self
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        loadFirebaseUserInfo()
        invokedViewWillAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.coordinator?.removeThisChildCoordinators()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    private func bindUI() {
        let input = InputInfoViewModel.Input(invokedViewWillAppear: invokedViewWillAppear)
        
        let output = viewModel?.trensform(input)
        
        output?.userInfo
            .map { user in
                user?.userName
            }
            .bind(to: inputInfoView.userNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.userInfo
            .map { user in
                String(user?.age ?? 0)
            }
            .bind(to: inputInfoView.userAgeTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.userInfo
            .map { user in
                user?.area
            }
            .bind(to: inputInfoView.userAreaTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.userInfo
            .do(onNext: { [weak self] user in
                switch user?.gender {
                case "남성":
                    self?.inputInfoView.maleButton.isSelected = true
                    self?.inputInfoView.femaleButton.isSelected = false
                case "여성":
                    self?.inputInfoView.maleButton.isSelected = false
                    self?.inputInfoView.femaleButton.isSelected = true
                default:
                    print("userFeet 비워져있음")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        output?.userInfo
            .do(onNext: { [weak self] user in
                switch user?.mainUsedFeet {
                case "오른발":
                    self?.inputInfoView.rightFootButton.isSelected = true
                case "왼발":
                    self?.inputInfoView.leftFootButton.isSelected = true
                case "양발":
                    self?.inputInfoView.bothFeetButton.isSelected = true
                default:
                    print("userFeet 비워져있음")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        output?.userInfo
            .do(onNext: { [weak self] user in
                switch user?.position {
                case "FW":
                    self?.inputInfoView.fwButton.isSelected = true
                case "MF":
                    self?.inputInfoView.mfButton.isSelected = true
                case "DF":
                    self?.inputInfoView.dfButton.isSelected = true
                case "GK":
                    self?.inputInfoView.gkButton.isSelected = true
                default:
                    print("userPosition 비워져있음")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        //    private func isInfoCompleted() {
        //        guard
        //            inputInfoView.userNameTextField.text != nil,
        //            inputInfoView.userAgeTextField.text != nil,
        //            inputInfoView.userAreaTextField.text != nil,
        //            inputInfoView.maleButton.isSelected ||
        //            inputInfoView.femaleButton.isSelected,
        //            inputInfoView.fwButton.isSelected || inputInfoView.mfButton.isSelected || inputInfoView.dfButton.isSelected || inputInfoView.gkButton.isSelected
        //        else {
        //            inputInfoView.nextButton.setTitle("모든 항목을 작성해주세요", for: .normal)
        //            inputInfoView.nextButton.setTitleColor(.gray, for: .normal)
        //            return inputInfoView.nextButton.isEnabled = false
        //        }
        //        inputInfoView.nextButton.setTitle("작성 완료", for: .normal)
        //        inputInfoView.nextButton.setTitleColor(.white, for: .normal)
        //        return inputInfoView.nextButton.isEnabled = true
        //    }
    }
    
    // MARK: - Selectors
    
    @objc
    func nextButtonTapped(_ sender: UIButton) {
        print("DEBUG: InputInfoViewController - nextButtonTapped")
        
        FirebaseAPI.shared.updateUser(User(dictionary: ["userName" : userName,
                                                        "age" : age,
                                                        "gender" : gender,
                                                        "area" : area,
                                                        "mainUsedFeet" : mainUsedFeet,
                                                        "position" : position
                                                       ]))
        
        // MARK: - UserService의 User 업데이트 해주기
        
        FirebaseAPI.shared.readUser { [weak self] user in
            guard let self else { return }
            print("User로그인 완료: \(user)")
            
            //TODO: - 모달, push에 따라 분기처리
            viewModel?.coordinator?.dismissView()
            viewModel?.coordinator?.popInputInfoViewController()
        }
    }
    
    @objc
    func maleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.femaleButton.isSelected {
            inputInfoView.femaleButton.isSelected.toggle()
        }
        gender = sender.titleLabel?.text ?? ""
    }
    
    @objc
    func femaleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.maleButton.isSelected {
            inputInfoView.maleButton.isSelected.toggle()
        }
        gender = sender.titleLabel?.text ?? ""
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
