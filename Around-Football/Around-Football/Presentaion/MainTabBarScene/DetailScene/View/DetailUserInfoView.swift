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
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "유저 이름"
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleSmall
    }
    
    private let userGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userAgeLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userArea = UILabel().then {
        $0.text = "지역"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
        
    private lazy var userDetailInfoStackView = UIStackView().then { view in
        let subViews = [userGenderLabel,
                        createHDividerView(),
                        userAgeLabel,
                        createHDividerView(),
                        userArea]
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fill
        
        subViews.forEach { label in
            view.addArrangedSubview(label)
        }
    }
    
    private lazy var userStackView = UIStackView().then {
        $0.addArrangedSubviews(userNameLabel,
                               userDetailInfoStackView)
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fill
        $0.alignment = .leading
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
        userAgeLabel.text = String(user.age)
        userArea.text = user.area
    }
    
    private func configureUI() {
        addSubviews(profileImageView,
                    userStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        userStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
    }
    
    private func createHDividerView() -> UIView {
        return UIView().then {
            $0.backgroundColor = AFColor.grayScale300
            $0.snp.makeConstraints { make in
                make.width.equalTo(0.6)
                make.height.equalTo(10)
            }
        }
    }
}
