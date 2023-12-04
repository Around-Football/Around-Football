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
    
    var viewModel: InputInfoViewModel?
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    let inputInfoView: InputInfoView = InputInfoView()
    
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
        navigationItem.title = "추가정보 입력"
        invokedViewWillAppear.onNext(()) //유저 데이터 요청
        bindUI()
        bindRegionButton()
        bindNextButton()
        keyboardController()
        
        inputInfoView.userNameTextField.delegate = self
        inputInfoView.userAgeTextField.delegate = self
        
        inputInfoView.maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        inputInfoView.femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        
        inputInfoView.rightFootButton.addTarget(self, action: #selector(rightFootButtonTapped), for: .touchUpInside)
        inputInfoView.leftFootButton.addTarget(self, action: #selector(leftFootButtonTapped), for: .touchUpInside)
        inputInfoView.bothFeetButton.addTarget(self, action: #selector(bothFeetButtonTapped), for: .touchUpInside)
        
        inputInfoView.fwButton.addTarget(self, action: #selector(fwButtonTapped), for: .touchUpInside)
        inputInfoView.mfButton.addTarget(self, action: #selector(mfButtonTapped), for: .touchUpInside)
        inputInfoView.dfButton.addTarget(self, action: #selector(dfButtonTapped), for: .touchUpInside)
        inputInfoView.gkButton.addTarget(self, action: #selector(gkButtonTapped), for: .touchUpInside)
        
        inputInfoView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        invokedViewWillAppear.onNext(()) //유저 데이터 요청
    //    }
    
    // MARK: - Helpers
    
    private func bindRegionButton() {
        inputInfoView.regionSubject.subscribe(onNext: { [weak self] region in
            guard let self else { return }
            let area = region
            viewModel?.area.accept(area)
            viewModel?.updateData()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        viewModel?.inputUserInfo
            .map({ user in
                guard user.userName != "",
                      user.age != 0,
                      user.gender != "",
                      user.area != "",
                      user.mainUsedFeet != "",
                      !user.position.isEmpty
                else {
                    return true
                }
                
                return false
            })
            .bind(onNext: { [weak self] bool in
                guard let self else { return }
                if bool == true { //비어있는게 트루라면
                    inputInfoView.nextButton.setTitle("모든 항목을 작성해주세요", for: .normal)
                    inputInfoView.nextButton.setTitleColor(.gray, for: .normal)
                    return inputInfoView.nextButton.isEnabled = false
                } else {
                    inputInfoView.nextButton.setTitle("작성 완료", for: .normal)
                    inputInfoView.nextButton.setTitleColor(.white, for: .normal)
                    return inputInfoView.nextButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
    }
    
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
            .bind(to: inputInfoView.regionFilterButton.rx.title())
            .disposed(by: disposeBag)
        
        output?.userInfo
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] user in
                guard let self else { return }
                switch user?.gender {
                case "남성":
                    inputInfoView.maleButton.isSelected = true
                case "여성":
                    inputInfoView.femaleButton.isSelected = true
                default:
                    print("userFeet 비워져있음")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        output?.userInfo
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] user in
                guard let self else { return }
                switch user?.mainUsedFeet {
                case "오른발":
                    inputInfoView.rightFootButton.isSelected = true
                case "왼발":
                    inputInfoView.leftFootButton.isSelected = true
                case "양발":
                    inputInfoView.bothFeetButton.isSelected = true
                default:
                    print("userFeet 비워져있음")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        output?.userInfo
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] user in
                guard let self else { return }
                if let userPosition = user?.position {
                    for position in userPosition {
                        switch position {
                        case "FW":
                            inputInfoView.fwButton.isSelected = true
                        case "MF":
                            inputInfoView.mfButton.isSelected = true
                        case "DF":
                            inputInfoView.dfButton.isSelected = true
                        case "GK":
                            inputInfoView.gkButton.isSelected = true
                        default:
                            print("userPosition 비워져있음")
                        }
                    }
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Selectors
    
    @objc
    func nextButtonTapped(_ sender: UIButton) {
        print("DEBUG: InputInfoViewController - nextButtonTapped")
        
        viewModel?.inputUserInfo
            .observe(on: MainScheduler.instance)
            .subscribe { user in
                FirebaseAPI.shared.updateUser(user)
                UserService.shared.currentUser_Rx.onNext(user)
            }
            .disposed(by: disposeBag)
        
        
        //로그인 or 설정뷰에 따라 다르게 이동
        viewModel?.coordinator?.dismissView()
        viewModel?.coordinator?.popInputInfoViewController()
    }
    
    @objc
    func maleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.femaleButton.isSelected {
            inputInfoView.femaleButton.isSelected.toggle()
        }
        if sender.isSelected {
            let gender = sender.titleLabel?.text
            viewModel?.gender.accept(gender)
            viewModel?.updateData()
        } else {
            viewModel?.gender.accept(nil)
            viewModel?.updateData()
        }
    }
    
    @objc
    func femaleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if inputInfoView.maleButton.isSelected {
            inputInfoView.maleButton.isSelected.toggle()
        }
        if sender.isSelected {
            let gender = sender.titleLabel?.text
            viewModel?.gender.accept(gender)
            viewModel?.updateData()
        } else {
            viewModel?.gender.accept(nil)
            viewModel?.updateData()
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
        if sender.isSelected {
            let mainUsedFeet = sender.titleLabel?.text
            viewModel?.mainUsedFeet.accept(mainUsedFeet)
            viewModel?.updateData()
        } else {
            viewModel?.mainUsedFeet.accept(nil)
            viewModel?.updateData()
        }
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
        if sender.isSelected {
            let mainUsedFeet = sender.titleLabel?.text
            viewModel?.mainUsedFeet.accept(mainUsedFeet)
            viewModel?.updateData()
        } else {
            viewModel?.mainUsedFeet.accept(nil)
            viewModel?.updateData()
        }
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
        if sender.isSelected {
            let mainUsedFeet = sender.titleLabel?.text
            viewModel?.mainUsedFeet.accept(mainUsedFeet)
            viewModel?.updateData()
        } else {
            viewModel?.mainUsedFeet.accept(nil)
            viewModel?.updateData()
        }
    }
    
    @objc
    func fwButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.insert(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        } else {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.remove(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        }
    }
    
    @objc
    func mfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.insert(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        } else {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.remove(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        }
    }
    
    @objc
    func dfButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.insert(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        } else {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.remove(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        }
    }
    
    @objc
    func gkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.insert(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        } else {
            guard let arr = viewModel?.position.value else { return }
            var positionSet = Set(arr)
            positionSet.remove(sender.titleLabel?.text)
            viewModel?.position.accept(Array(positionSet))
            viewModel?.updateData()
        }
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
