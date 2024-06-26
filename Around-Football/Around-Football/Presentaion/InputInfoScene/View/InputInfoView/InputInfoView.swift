//
//  InputInfoView.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class InputInfoView: UIView {

    // MARK: - Properties
    
    private lazy var mainScrollView = UIScrollView()
    private let contentView = UIView()
    
    private let userNameLabel = AFTitleSmall(title: "닉네임")
    private let userAgeLabel = AFTitleSmall(title: "나이")
    private let userAreaLabel = AFTitleSmall(title: "지역")
    
    private let userGenderLabel = AFTitleSmall(title: "성별")
    let maleButton = AFMediumButton(buttonTitle: "남성", color: AFColor.primary)
    let femaleButton = AFMediumButton(buttonTitle: "여성", color: AFColor.primary)

    private let userMainUsedFeetLabel = AFTitleSmall(title: "주발")
    let rightFootButton = AFMediumButton(buttonTitle: "오른발", color: AFColor.primary)
    let leftFootButton = AFMediumButton(buttonTitle: "왼발", color: AFColor.primary)
    let bothFeetButton = AFMediumButton(buttonTitle: "양발", color: AFColor.primary)
    
    private let userPositionLabel = AFTitleSmall(title: "선호 포지션")
    let fwButton = AFMediumButton(buttonTitle: "FW", color: AFColor.primary)
    let mfButton = AFMediumButton(buttonTitle: "MF", color: AFColor.primary)
    let dfButton = AFMediumButton(buttonTitle: "DF", color: AFColor.primary)
    let gkButton = AFMediumButton(buttonTitle: "GK", color: AFColor.primary)
    
    let nextButton = AFButton(buttonTitle: "확인", color: .black)

    private let titleLabel = UILabel().then {
        $0.text = "추가 정보를 작성해주세요"
        $0.font = AFFont.titleMedium
    }
    
    // 이름
    private lazy var userNameStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userNameLabel,
                               userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        userNameTextField.makeSideAutoLayout()
    }
    
    let userNameTextField = UITextField().then {
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.placeholder = "닉네임을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = AFColor.grayScale100.cgColor
        $0.font = AFFont.text
        $0.returnKeyType = .done
    }
    
    // 나이
    let ageMenus: [String]  = ["10대", "20대", "30대", "40대", "50대 이상"]
    lazy var ageFilterButton = AFMenuButton(buttonTitle: "나이 선택", menus: ageMenus)
    private lazy var userAgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userAgeLabel,
                               ageFilterButton)
        ageFilterButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    // 지역
    let regionMenus: [String]  = ["서울", "인천", "부산", "대구", "울산", "대전", "광주",
                                  "세종특별자치시", "경기", "강원특별자치도", "충북", "충남",
                                  "경북", "경남", "전북", "전남", "제주특별자치도"]
    lazy var regionFilterButton = AFMenuButton(buttonTitle: "지역 선택", menus: regionMenus)
    private lazy var userRegionStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userAreaLabel,
                               regionFilterButton)
        regionFilterButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    // 성별
    private lazy var userGenderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 8
        $0.addArrangedSubviews(userGenderLabel,
                               userGenderButtonStackView)
        
        userGenderButtonStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }

    private lazy var userGenderButtonStackView = UIStackView().then {
        let emptyView = UIView()
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
        $0.addArrangedSubviews(maleButton,
                               femaleButton,
                               emptyView)
        
        maleButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // 주발
    private lazy var userMainUsedFeetStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userMainUsedFeetLabel,
                               userMainUsedFeetButtonStackView)
        
        userMainUsedFeetButtonStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private lazy var userMainUsedFeetButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(rightFootButton,
                               leftFootButton,
                               bothFeetButton)
        
        rightFootButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        leftFootButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        bothFeetButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // 포지션
    private lazy var userPositionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 8
        $0.addArrangedSubviews(userPositionLabel,
                               userPositionButtonStackView)
        
        userPositionButtonStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private lazy var userPositionButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .leading
        $0.spacing = 7
        $0.addArrangedSubviews(fwButton,
                               mfButton,
                               dfButton,
                               gkButton)
        
        fwButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        mfButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        dfButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        gkButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        addSubviews(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel,
                                userNameStackView,
                                userAgeStackView,
                                userGenderStackView,
                                userRegionStackView,
                                userMainUsedFeetStackView,
                                userPositionStackView,
                                nextButton)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        userNameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        userAgeStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalTo(userRegionStackView.snp.leading).offset(-10)
            make.width.equalTo(userRegionStackView.snp.width)
        }
        
        userRegionStackView.snp.makeConstraints { make in
            make.centerY.equalTo(userAgeStackView.snp.centerY)
            make.leading.equalTo(userAgeStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.width.equalTo(userAgeStackView.snp.width)
            make.height.equalTo(userAgeStackView.snp.height)
        }
        
        userGenderStackView.snp.makeConstraints { make in
            make.top.equalTo(userAgeStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(65)
        }
        
        userMainUsedFeetStackView.snp.makeConstraints { make in
            make.top.equalTo(userGenderStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(65)
        }
        
        userPositionStackView.snp.makeConstraints { make in
            make.top.equalTo(userMainUsedFeetStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.height.equalTo(65)
        }
        
        //TODO: - 아래 고정하기
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(userPositionStackView.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(contentView.snp.bottom).offset(SuperviewOffsets.bottomPadding)
            make.height.equalTo(55)
        }
    }
}


