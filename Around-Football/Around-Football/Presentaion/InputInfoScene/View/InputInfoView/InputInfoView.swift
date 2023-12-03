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
    let regionSubject = PublishSubject<String?>()
    
    private lazy var mainScrollView = UIScrollView().then {
        $0.backgroundColor = .systemBackground
    }
    private let contentView = UIView()
    
    // 이름
    private lazy var userNameStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userNameLabel,
                               userNameTextField)
        userNameTextField.makeSideAutoLayout()
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let userNameTextField = UITextField().then {
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.placeholder = "이름을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 15)
    }
    
    // 나이
    private lazy var userAgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userAgeLabel,
                               userAgeTextField)
        userAgeTextField.makeSideAutoLayout()
    }
    
    private let userAgeLabel = UILabel().then{
        $0.text = "나이"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let userAgeTextField = UITextField().then {
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.placeholder = "나이를 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 15)
        $0.keyboardType = .numberPad
    }
    
    // 성별
    private lazy var userGenderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userDetailSexLabel,
                               userDetailSexButtonStackView)
        userDetailSexButtonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
    }
    
    private let userDetailSexLabel = UILabel().then{
        $0.text = "성별"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var userDetailSexButtonStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubviews(maleButton,
                               femaleButton)
    }
    
    let maleButton = UIButton().then{
        $0.setTitle("남성", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
    
    let femaleButton = UIButton().then{
        $0.setTitle("여성", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
    
    // 지역
    private lazy var userAreaStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 100
        $0.addArrangedSubviews(userAreaLabel,
                               regionFilterButton)
    }
    
    private let userAreaLabel = UILabel().then{
        $0.text = "지역"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var regionFilterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        
        let button = UIButton(configuration: config).then {
            let image = UIImage(systemName: "chevron.down")
            $0.setTitle("지역 선택", for: .normal)
            $0.setTitleColor(.label, for: .normal)
            $0.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
            $0.layer.cornerRadius = LayoutOptions.cornerRadious
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.systemGray.cgColor
            $0.showsMenuAsPrimaryAction = true
        }
        
        let menus: [String]  = ["전체", "서울", "인천", "부산", "대구", "울산", "대전", "광주", "세종특별자치시", "경기", "강원특별자치도", "충북", "충남", "경북", "경남", "전북", "전남", "제주특별자치도"]
        
        button.menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                regionSubject.onNext(city)
                button.setTitle(city, for: .normal)
            }
        })
        
        return button
    }()
    
    // 주발
    private lazy var userMainUsedFeetStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userMainUsedFeetLabel,
                               userMainUsedFeetButtonStackView)
        userMainUsedFeetButtonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
    }
    
    private let userMainUsedFeetLabel = UILabel().then{
        $0.text = "주발"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var userMainUsedFeetButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(rightFootButton,
                               leftFootButton,
                               bothFeetButton)
    }
    
    let rightFootButton = UIButton().then {
        $0.setTitle("오른발", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
    }
    
    let leftFootButton = UIButton().then {
        $0.setTitle("왼발", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
    }
    
    let bothFeetButton = UIButton().then {
        $0.setTitle("양발", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
    }
    
    // 포지션
    private lazy var userPositionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userPositionLabel,
                               userPositionButtonStackView)
        userPositionButtonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
    }
    
    private let userPositionLabel = UILabel().then{
        $0.text = "선호 포지션(복수선택 가능)"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var userPositionButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(fwButton,
                               mfButton,
                               dfButton,
                               gkButton)
    }
    
    let fwButton = UIButton().then {
        $0.setTitle("FW", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
    }
    
    let mfButton = UIButton().then {
        $0.setTitle("MF", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
    }
    
    let dfButton = UIButton().then {
        $0.setTitle("DF", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
    }
    
    let gkButton = UIButton().then {
        $0.setTitle("GK", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
    }
    
    // 다음 버튼
    let nextButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.clipsToBounds = true
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
        contentView.addSubviews(userNameStackView,
                                userAgeStackView,
                                userGenderStackView,
                                userAreaStackView,
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
        
        userNameStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userAgeStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userAgeStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userGenderStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userGenderStackView.snp.makeConstraints { make in
            make.top.equalTo(userAgeStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userAreaStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(userGenderStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userMainUsedFeetStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userMainUsedFeetStackView.snp.makeConstraints { make in
            make.top.equalTo(userAreaStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
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
            make.height.equalTo(50)
        }
    }
}


