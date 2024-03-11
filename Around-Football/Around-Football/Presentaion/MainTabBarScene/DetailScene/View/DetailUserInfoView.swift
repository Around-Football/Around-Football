//
//  DetailUserInfoView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DetailUserInfoView: UIView {
    
    // MARK: - Properties
    
    private let isInfoTab: Bool
    
    //설정버튼 카메라
    private let cameraImage = UIImageView(image: UIImage(named: AFIcon.cameraButton))
    
    lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: AFIcon.fieldImage)
        $0.contentMode = .scaleAspectFill
        if isInfoTab {
            $0.layer.cornerRadius = 64/2
        } else {
            $0.layer.cornerRadius = 20
        }
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
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
    
    private let userFoot = UILabel().then {
        $0.text = ""
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userPosition = UILabel().then {
        $0.text = ""
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private lazy var userDetailInfoStackView = UIStackView().then { view in
        let subViews = [userGenderLabel,
                        createHDividerView(),
                        userAgeLabel,
                        userDetailInfoSettingViewStackView]
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fill
        
        subViews.forEach { label in
            view.addArrangedSubview(label)
        }
    }
    
    private lazy var userDetailInfoSettingViewStackView = UIStackView().then { view in
        let subViews = [createHDividerView(),
                        userFoot,
                        createHDividerView(),
                        userPosition]
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
        $0.spacing = 8
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    // MARK: - Lifecycles
    
    init(frame: CGRect = .zero, isInfoTab: Bool = false) {
        self.isInfoTab = isInfoTab
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc
    func imageViewTapped() {
        // TODO: - 사진 크게 보기 추가?
        print("이미지 눌림")
    }
    
    // MARK: - Helpers
    
    func setValues(user: User?, isSettingView: Bool = false) {
        if user == nil {
            userNameLabel.text = "로그인 해주세요"
            userDetailInfoStackView.isHidden = true
            profileImageView.kf.setImage(with: URL(string: AFIcon.defaultImageURL),
                                         placeholder: AFIcon.defaultFieldImage)
        } else {
            userDetailInfoStackView.isHidden = false
            userDetailInfoSettingViewStackView.isHidden = true
            userNameLabel.text = user?.userName
            userGenderLabel.text = user?.gender
            userAgeLabel.text = String(user?.age ?? "")
            userArea.text = user?.area
            profileImageView.kf.setImage(with: URL(string: user?.profileImageUrl ?? AFIcon.defaultImageURL),
                                         placeholder: AFIcon.defaultFieldImage)
        }
        
        if isSettingView {
            userFoot.text = user?.mainUsedFeet
            userPosition.text = user?.position.joined(separator: " • ")
            userDetailInfoSettingViewStackView.isHidden = false
        }
    }
    
    private func configureUI() {
        addSubviews(profileImageView,
                    userStackView)
        if isInfoTab {
            profileImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(64)
                make.width.equalTo(64)
                
                addSubview(cameraImage)
                cameraImage.snp.makeConstraints { make in
                    make.width.height.equalTo(20)
                    make.trailing.equalTo(profileImageView.snp.trailing)
                    make.bottom.equalTo(profileImageView.snp.bottom)
                }
            }
        } else {
            profileImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(40)
            }
        }
        
        userStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(14)
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
