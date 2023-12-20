//
//  InfoViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa

final class InfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: InfoViewModel
    private var disposeBag = DisposeBag()
    private let profileAndEditView = ProfileAndEditView()
    
    private let iconAndImage: [(icon: String, title: String)] = [
        (icon: "star", title: "관심 글"),
        (icon: "doc.text", title: "작성 글"),
        (icon: "ellipsis.message", title: "신청 글"),
    ]
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.cellID)
        return cv
    }()
    
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1.0
        $0.addArrangedSubview(InfoArrangedView())
        $0.addArrangedSubview(InfoArrangedView())
        $0.addArrangedSubview(InfoArrangedView())
        $0.addArrangedSubview(InfoArrangedView())
    }
    
    private lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
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
        configureStackView()
        bindButtonActionHandler()
        bindUserInfo()
        bindLogoutButton()
    }
    
    // MARK: - Selectors
    
    @objc
    func logoutButtonTapped() {
        UserService.shared.logout()
        viewModel.coordinator?.presentLoginViewController()
        tabBarController?.selectedIndex = 0 //로그아웃하면 메인탭으로 이동
    }
    
    // MARK: - Helpers
    
    private func bindLogoutButton() {
        UserService.shared.currentUser_Rx.bind { [weak self] user in
            guard let self else { return }
            if user?.id == nil {
                logoutButton.setTitle("로그인", for: .normal)
            } else {
                logoutButton.setTitle("로그아웃", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindUserInfo() {
        UserService.shared.currentUser_Rx.bind { [weak self] user in
            guard let self else { return }
            if user == nil {
                profileAndEditView.userName.text = "로그인 해주세요"
            } else {
                profileAndEditView.userName.text = user?.userName
            }
        }.disposed(by: disposeBag)
    }
    
    private func configureStackView() {
        UserService.shared.currentUser_Rx
            .bind { [weak self] user in
                guard
                    let self,
                    let user,
                    let views = infoStackView.arrangedSubviews as? [InfoArrangedView],
                    let contents = [String(user.age), user.area, user.mainUsedFeet, user.position.joined(separator: ", ")] as? [String]
                else { return }
                
                let titles = ["성별", "지역", "주발", "포지션"]
            
            (0..<titles.count).forEach {
                views[$0].setValues(name: titles[$0], content: contents[$0])
            }
        }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "프로필"
        
        view.addSubviews(profileAndEditView,
                         infoCollectionView,
                         infoStackView)
        
        view.addSubview(logoutButton)
        
        profileAndEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        infoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileAndEditView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset((SuperviewOffsets.leadingPadding))
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo((UIScreen.main.bounds.width / 3) - 20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(infoCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset((SuperviewOffsets.leadingPadding))
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(150)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
    
    private func bindButtonActionHandler() {
        profileAndEditView.editButtonActionHandler = { [weak self] in
            guard let self else { return }
            
            UserService.shared.currentUser_Rx
                .take(1) //버튼 누를때만 요청하도록 1번만! 아니면 연동되서 값 바뀔때마다 실행됨
                .subscribe(onNext: { [weak self] user in
                    guard let self else { return }
                    if user?.id == nil {
                        viewModel.coordinator?.presentLoginViewController()
                    } else {
                        viewModel.coordinator?.pushEditView()
                    }
                }).disposed(by: disposeBag)
        }
        
        profileAndEditView.settingButtonActionHandler = { [weak self] in
            guard let self else { return }
            
            UserService.shared.currentUser_Rx
                .take(1)
                .subscribe(onNext: { [weak self] user in
                    guard let self else { return }
                    if user?.id == nil {
                        viewModel.coordinator?.presentLoginViewController()
                    } else {
                        viewModel.coordinator?.pushEditView()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}

//TODO: -Rx 리팩토링

extension InfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 3) - 20
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        iconAndImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfoCell.cellID,
            for: indexPath
        ) as? InfoCell else {
            return UICollectionViewCell()
        }

        cell.setValues(icon: iconAndImage[indexPath.item].icon,
                       title: iconAndImage[indexPath.item].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = iconAndImage[indexPath.item].title
        switch title {
        case _ where "관심 글" == title:
            viewModel.coordinator?.pushBookmarkPostViewController()
        case _ where "작성 글" == title:
            viewModel.coordinator?.pushWrittenPostViewController()
        case _ where "신청 글" == title:
            viewModel.coordinator?.pushApplicationPostViewController()
        default:
            print("cell 없음")
        }
    }
}
