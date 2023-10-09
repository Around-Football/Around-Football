//
//  ProfileAndEditViewViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/9/23.
//

import UIKit

import SnapKit
import Then

final class ProfileAndEditView: UIView {
    
    // MARK: - Properties
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysOriginal)
        $0.tintColor = .label
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private var userName = UILabel().then {
        $0.text = "thekoon"
        $0.font = .systemFont(ofSize: 15)
    }
    
    private lazy var editButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var settingButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        let image = UIImage(systemName: "gear", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func editButtonTapped() {
        print("DEBUG: editButtonTapped")
    }
    
    @objc private func settingButtonTapped() {
        print("DEBUG: settingButtonTapped")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubviews(
            profileImageView,
            userName,
            editButton,
            settingButton)
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(20)
            make.leading.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        userName.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo(settingButton.snp.leading).offset(-30)
        }
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
