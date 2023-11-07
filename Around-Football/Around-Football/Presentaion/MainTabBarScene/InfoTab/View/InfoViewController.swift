//
//  InfoViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

protocol InfoViewControllerDelegate: AnyObject {
    func showLoginViewController()
    func pushToEditView()
    func pushToSettingView()
}

final class InfoViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: InfoViewControllerDelegate?
    
    private let loginViewModel = LoginViewModel()
    private let profileAndEditView = ProfileAndEditView()
    
    private let iconAndImage: [(icon: String, title: String)] = [
        (icon: "heart", title: "관심 글"),
        (icon: "doc.text", title: "작성 글"),
        (icon: "trophy", title: "트로피"),
        (icon: "clock", title: "풋살장 예약"),
        (icon: "ellipsis.message", title: "리뷰 작성"),
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureStackView()
        setButtonDelegate()
    }
    
    // MARK: - Selectors
    
    @objc 
    func logoutButtonTapped() {
        loginViewModel.logout()
        delegate?.showLoginViewController() //로그인 모달뷰 나옴
        tabBarController?.selectedIndex = 0 //로그아웃하면 메인탭으로 이동
    }
    
    // MARK: - Helpers
    
    private func configureStackView() {
        if let views = infoStackView.arrangedSubviews as? [InfoArrangedView] {
            views[0].setValues(name: "리뷰", content: "(1.0 - 1.0)")
            views[1].setValues(name: "매너", content: "0")
            views[2].setValues(name: "성별", content: "남자")
            views[3].setValues(name: "구력", content: "1년")
        }
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
            make.height.equalTo(240)
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
    
    private func setButtonDelegate() {
        profileAndEditView.editButtonActionHandler = { [weak self] in
            guard let self else { return }
            delegate?.pushToEditView()
        }
        profileAndEditView.settingButtonActionHandler = { [weak self] in
            guard let self else { return }
            delegate?.pushToSettingView()
        }
    }
}

extension InfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 3) - 20
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconAndImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}

//이전 delegate방식
//extension InfoViewController: InfoDelegate {
//    func moveToDatailVC() {
//        let controller = DetailViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
//    
//    func moveToInviteVC() {
//        let controller = InviteViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
//}
