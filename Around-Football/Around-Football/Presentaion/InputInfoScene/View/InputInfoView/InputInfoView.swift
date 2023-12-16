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
    
    //버튼으로 지역 누르면 보내줌
    let ageSubject = PublishSubject<String?>()
    let regionSubject = PublishSubject<String?>()
    
    private let userNameLabel = AFTitleSmall(title: "이름")
    private let userAgeLabel = AFTitleSmall(title: "나이")
    private let userAreaLabel = AFTitleSmall(title: "지역")
    
    private let userGenderLabel = AFTitleSmall(title: "성별")
    let maleButton = AFSmallButton(buttonTitle: "남성")
    let femaleButton = AFSmallButton(buttonTitle: "여성")

    private let userMainUsedFeetLabel = AFTitleSmall(title: "주발")
    let rightFootButton = AFSmallButton(buttonTitle: "오른발")
    let leftFootButton = AFSmallButton(buttonTitle: "왼발")
    let bothFeetButton = AFSmallButton(buttonTitle: "양발")
    
    private let userPositionLabel = AFTitleSmall(title: "선호 포지션")
    let fwButton = AFSmallButton(buttonTitle: "FW")
    let mfButton = AFSmallButton(buttonTitle: "MF")
    let dfButton = AFSmallButton(buttonTitle: "DF")
    let gkButton = AFSmallButton(buttonTitle: "GK")
    
    // 다음 버튼
    let nextButton = AFButton(buttonTitle: "확인", color: .black)
    
    private lazy var mainScrollView = UIScrollView().then {
        $0.backgroundColor = .systemBackground
    }
    private let contentView = UIView()
    
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
        $0.placeholder = "이름을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = AFColor.grayScale100.cgColor
        $0.font = AFFont.text
    }
    
    // 나이
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
    
    //나이
    lazy var ageFilterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 30
        
        let button = UIButton(configuration: config).then {
            let image = UIImage(systemName: "chevron.down")
            $0.setTitle("나이 선택", for: .normal)
            $0.setTitleColor(.label, for: .normal)
            $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = AFColor.grayScale100.cgColor
            $0.showsMenuAsPrimaryAction = true
            $0.semanticContentAttribute = .forceRightToLeft
        }
        
        let menus: [String]  = ["10대", "20대", "30대", "40대", "50대 이상"]
        
        button.menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                ageSubject.onNext(city)
                button.setTitle(city, for: .normal)
            }
        })
        
        return button
    }()
    
    // 지역
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

    lazy var regionFilterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 30
        
        let button = UIButton(configuration: config).then {
            let image = UIImage(systemName: "chevron.down")
            $0.setTitle("지역 선택", for: .normal)
            $0.setTitleColor(.label, for: .normal)
            $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = AFColor.grayScale100.cgColor
            $0.showsMenuAsPrimaryAction = true
            $0.semanticContentAttribute = .forceRightToLeft
        }
        
        let menus: [String]  = ["서울", "인천", "부산", "대구", "울산", "대전", "광주", "세종특별자치시", "경기", "강원특별자치도", "충북", "충남", "경북", "경남", "전북", "전남", "제주특별자치도"]
        
        button.menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                regionSubject.onNext(city)
                button.setTitle(city, for: .normal)
            }
        })
        
        return button
    }()
    
    // 성별
    private lazy var userGenderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 8
        $0.addArrangedSubviews(userGenderLabel,
                               userGenderButtonStackView)
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
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(40)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(40)
        }
        
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
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
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(40)
        }
        
        leftFootButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(40)
        }
        
        bothFeetButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
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
    }
    
    private lazy var userPositionButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .leading
        $0.spacing = 8
        $0.addArrangedSubviews(fwButton,
                               mfButton,
                               dfButton,
                               gkButton)
        
        fwButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 4)
            make.height.equalTo(40)
        }
        
        mfButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 4)
            make.height.equalTo(40)
        }
        
        dfButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 4)
            make.height.equalTo(40)
        }
        
        gkButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 4)
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
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(mainScrollView.snp.width)
            make.height.equalTo(mainScrollView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        userNameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userAgeStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userAgeStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalTo(userRegionStackView.snp.leading).offset(-10)
            make.bottom.equalTo(userGenderStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
            make.width.equalTo(userRegionStackView.snp.width)
        }
        
        userRegionStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalTo(userAgeStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userGenderStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
            make.width.equalTo(userAgeStackView.snp.width)
        }
        
        userGenderStackView.snp.makeConstraints { make in
            make.top.equalTo(userRegionStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userMainUsedFeetStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
            make.height.equalTo(65) //안넣으면 성별 lable 표시안되는 이슈있음
        }
        
        userMainUsedFeetStackView.snp.makeConstraints { make in
            make.top.equalTo(userRegionStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userPositionStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userPositionStackView.snp.makeConstraints { make in
            make.top.equalTo(userMainUsedFeetStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(userPositionStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding).priority(.required)
            make.height.equalTo(55)
        }
    }
}


