//
//  InfoViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit
import PhotosUI

import FirebaseAuth
import RxSwift
import RxCocoa

final class InfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: InfoViewModel
    private var disposeBag = DisposeBag()
    private let detailUserInfoView = DetailUserInfoView()
    private let infoHeaderView = InfoHeaderView()
    private let imageSubject = PublishSubject<UIImage>()
    
    private lazy var infoTableView = UITableView().then {
        $0.register(InfoCell.self, forCellReuseIdentifier: InfoCell.cellID)
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets().with({ edge in
            edge.left = 0
            edge.right = 0
        })
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let lineView2 = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUserInfo()
        bindTableView()
        configureSettingButton()
        setUserImage()
    }
    
    // MARK: - Selectors
    
    @objc
    func imageViewTapped() {
        print("설정 눌림")
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        viewModel.coordinator?.presentPHPickerView(picker: picker)
    }
    
    @objc
    func logoutButtonTapped() {
        UserService.shared.logout()
        viewModel.coordinator?.presentLoginViewController()
        tabBarController?.selectedIndex = 0 //로그아웃하면 메인탭으로 이동
    }
    
    // MARK: - Helpers
    
    func setUserImage() {
        detailUserInfoView.profileImageView.isUserInteractionEnabled = true
        detailUserInfoView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        
        viewModel
            .uploadImage(InfoViewModel.Input(setUserProfileImage: imageSubject))
    }
    
    private func configureSettingButton() {
        infoHeaderView.settingButtonActionHandler = { [weak self] in
            guard let self else { return }
            guard let _ = try? UserService.shared.currentUser_Rx.value() else {
                viewModel.coordinator?.presentLoginViewController()
                return
            }
            
            viewModel.coordinator?.pushSettingView()
        }
    }
    
    private func bindTableView() {
        
        viewModel
            .menusObservable
            .bind(to: infoTableView.rx.items(cellIdentifier: InfoCell.cellID,
                                              cellType: InfoCell.self)) { index, item, cell in
            cell.setValues(title: item)
        }.disposed(by: disposeBag)
        
        infoTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let _ = try? UserService.shared.currentUser_Rx.value() else {
                    viewModel.coordinator?.presentLoginViewController()
                    return
                }

                switch indexPath.row {
                case 0:
                    viewModel.coordinator?.pushEditView()
                case 1:
                    viewModel.coordinator?.pushBookmarkPostViewController()
                case 2:
                    viewModel.coordinator?.pushApplicationPostViewController()
                case 3:
                    viewModel.coordinator?.pushWrittenPostViewController()
                default:
                    print("DEBUG: SettingCell 없음")
                }

                // 선택 효과 해제
                infoTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUserInfo() {
        UserService.shared.currentUser_Rx.bind { [weak self] user in
            guard let self else { return }
            detailUserInfoView.setValues(user: user, isSettingView: true)
            viewModel.user = user
            
            //user 사진 업데이트시 반영
            guard let user else { return }
            detailUserInfoView.profileImageView.kf.setImage(with: URL(string: user.profileImageUrl) ?? URL(string: "https://firebasestorage.googleapis.com:443/v0/b/around-football.appspot.com/o/8930189C-6983-4A48-9E02-321C8484897E%2F846FF6B7-454F-4EAB-8C43-89DD402FE0D21703843637.667433?alt=media&token=5e8c3184-0dba-4cec-8b04-910c8e3c03e0")!,
                                                            placeholder: UIImage(named: AFIcon.fieldImage))
            
        }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        infoTableView.rowHeight = 60
        
        view.backgroundColor = .white
        
        view.addSubviews(infoHeaderView,
                         detailUserInfoView,
                         lineView,
                         infoTableView,
                         lineView2)
        
        infoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(infoHeaderView.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(64)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
        
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(infoTableView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
    }
}

extension InfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    print("image있음")
                    self?.imageSubject.onNext(image)
                } else {
                    print("image없음")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true)
    }
}
