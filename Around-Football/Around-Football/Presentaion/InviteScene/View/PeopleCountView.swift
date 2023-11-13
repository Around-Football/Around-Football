//
//  PeopleCountView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

class PeopleCountView: UIView {
    
    // MARK: - Properties
    
    //선택된 사람 수
    private var count = 0 {
        didSet {
            peopleCountLabel.text = "\(count) 명"
        }
    }
    
    private let peopleCountTitleLabel = UILabel().then {
        $0.text = "인원"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private lazy var peopleCountLabel = UILabel().then {
        $0.text = "\(count) 명"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 15)
    }
    
    private lazy var minusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
    }
    
    private lazy var plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(plusCount), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc 
    private func minusCount() {
        count = count > 0 ? count - 1 : count
    }
    
    @objc 
    private func plusCount() {
        count = count < 25 ? count + 1 : count
    }

    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(peopleCountTitleLabel,
                    peopleCountLabel,
                    minusButton,
                    plusButton)
        
        peopleCountTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        peopleCountLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleCountTitleLabel.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(peopleCountTitleLabel.snp.bottom).offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalTo(peopleCountLabel.snp.leading).offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(peopleCountTitleLabel.snp.bottom).offset(-10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
