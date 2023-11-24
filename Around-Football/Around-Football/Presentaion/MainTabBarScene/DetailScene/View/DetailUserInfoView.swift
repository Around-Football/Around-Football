//
//  DetailUserInfoView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import SnapKit
import Then

final class DetailUserInfoView: UIView {
    
    // MARK: - Properties
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "최승현"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let userGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userAgeLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userArea = UILabel().then {
        $0.text = "지역"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let mainUsedFeet = UILabel().then {
        $0.text = "주발"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userPosition = UILabel().then {
        $0.text = "포지션"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private lazy var userDetailInfoStackView = UIStackView().then { view in
        let subViews = [userGenderLabel,
                        createDotView(),
                        userAgeLabel,
                        createDotView(),
                        userArea,
                        createDotView(),
                        mainUsedFeet,
                        createDotView(),
                        userPosition]
        
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fill
        
        subViews.forEach { label in
            view.addArrangedSubview(label)
        }
    }
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    //TODO: - 표시할 유저정보 정하고 바인딩하기
    
    func setValues(user: User) {
        userNameLabel.text = user.userName
        userGenderLabel.text = user.gender
        userAgeLabel.text = String(user.age ?? 0) + "세"
        userArea.text = user.area
        mainUsedFeet.text = user.mainUsedFeet
        userPosition.text = user.position.map { $0 ?? "" }.joined(separator: ", ")
    }
    
    private func configureUI() {
        addSubviews(profileImageView,
                    userNameLabel,
                    userDetailInfoStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.leading.equalTo(profileImageView.snp.trailing).offset(SuperviewOffsets.leadingPadding)
        }
        
        userDetailInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
    
    private func createDotView() -> UILabel {
        return UILabel().then {
            $0.text = "•"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 10)
        }
    }
}
