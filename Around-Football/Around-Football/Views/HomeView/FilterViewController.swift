//
//  FilterViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/20/23.
//

import UIKit

import SnapKit
import Then

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cities: [String]  = ["서울", "경기", "인천", "세종", "강원도", "충청도", "경상도", "전라도", "제주"]
    
    private let titleLabel = UILabel().then {
        $0.text = "찾고 싶은 지역을 선택해주세요"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        
        // 버튼 스타일 설정
        $0.setTitleColor(.blue, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.blue.cgColor
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var dismissButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        
        // 버튼 스타일 설정
        $0.setTitleColor(.red, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.red.cgColor
        $0.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let leftCityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    private let rightCityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    private let totalCityStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .top
        $0.spacing = 10
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 10
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        for city in cities {
            let cityButton : UIButton = {
                let button = UIButton()
                button.setTitle(city, for: .normal)
                
                // 버튼 스타일 설정
                button.setTitleColor(.systemGray, for: .normal)
                button.layer.cornerRadius = LayoutOptions.cornerRadious
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.systemGray.cgColor
                
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            // FIXME: - if 조건문이 과연 최선일까...
            
            if leftCityStackView.subviews.count < 5 {
                leftCityStackView.addArrangedSubview(cityButton)
            } else {
                rightCityStackView.addArrangedSubview(cityButton)
            }
        }
        
        totalCityStackView.addArrangedSubviews(leftCityStackView,
                                               rightCityStackView)
        
        buttonStackView.addArrangedSubviews(dismissButton,
                                            confirmButton)
        view.addSubviews(titleLabel,
                         totalCityStackView,
                         buttonStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        totalCityStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(totalCityStackView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    // MARK: - Seletors
    
    @objc
    func didTapConfirmButton() {
        
    }
    
    @objc
    func didTapDismissButton() {
        self.dismiss(animated: true)
    }
}
