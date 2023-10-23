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
    
    // MARK: Properties
    
    private var mainScrollView = UIScrollView().then {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 25
        $0.addArrangedSubviews(userNameStackView,
                               userAgeStackView,
                               userContactStackView,
                               userDetailSexStackView,
                               userAreaStackView,
                               userMainUsedFeetStackView,
                               userPositionStackView)
        
        userNameStackView.makeSideAutoLayout()
        userAgeStackView.makeSideAutoLayout()
        userContactStackView.makeSideAutoLayout()
        userDetailSexStackView.makeSideAutoLayout()
        userAreaStackView.makeSideAutoLayout()
        userMainUsedFeetStackView.makeSideAutoLayout()
        userPositionStackView.makeSideAutoLayout()
    }
    
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
        $0.setTitle("다음", for: .normal)
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
    
    func setupUI() {
        addSubviews(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        self.addSubview(nextButton)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
            //            make.width.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            //            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }
}


