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
    
    private let userDetailSex = UILabel().then {
        $0.text = "남"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userDetailReviewGrade = UILabel().then {
        $0.text = "리뷰"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userDetailCareer = UILabel().then {
        $0.text = "경력2년"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private let userDetailManner = UILabel().then {
        $0.text = "매너 0"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private lazy var userDetailInfoStackView = UIStackView().then { view in
        let subViews = [userDetailSex,
                        createDotView(),
                        userDetailReviewGrade,
                        createDotView(),
                        userDetailCareer,
                        createDotView(),
                        userDetailManner]
        
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
    
    private func configureUI() {
        addSubviews(profileImageView, userNameLabel, userDetailInfoStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        userDetailInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.bottom.equalToSuperview().offset(-20)
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
