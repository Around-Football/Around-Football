//
//  InputInfoView.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/17.
//

import UIKit

import Then
import SnapKit

class InputInfoView: UIView {
    
    // MARK: - Properties
    
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
    }
    
    // 연락처
    private lazy var userContactStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userContactLabel,
                               userContactTextField)
        userContactTextField.makeSideAutoLayout()
    }
    
    private let userContactLabel = UILabel().then{
        $0.text = "연락처"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let userContactTextField = UITextField().then {
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.placeholder = "연락처를 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 15)
    }
    
    // 성별
    private lazy var userDetailSexStackView = UIStackView().then {
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
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(userAreaLabel,
                               userAreaTextField)
        userAreaTextField.makeSideAutoLayout()
    }
    
    private let userAreaLabel = UILabel().then{
        $0.text = "지역(시/군/구)"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let userAreaTextField = UITextField().then{
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.placeholder = "지역을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = .systemFont(ofSize: 15)
    }
    
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
                                userContactStackView,
                                userDetailSexStackView,
                                userAreaStackView,
                                userMainUsedFeetStackView,
                                userPositionStackView,
                                nextButton)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(mainScrollView.contentLayoutGuide)
            make.width.equalTo(mainScrollView.frameLayoutGuide)
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
            make.bottom.equalTo(userContactStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userContactStackView.snp.makeConstraints { make in
            make.top.equalTo(userAgeStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userDetailSexStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userDetailSexStackView.snp.makeConstraints { make in
            make.top.equalTo(userContactStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(userAreaStackView.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        userAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(userDetailSexStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
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
            make.bottom.equalTo(nextButton.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(userPositionStackView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}


