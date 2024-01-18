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
    var count = 1 {
        didSet {
            peopleCountLabel.text = "\(count) 명"
        }
    }
    
    private let peopleCountTitleLabel = UILabel().then {
        $0.text = "모집인원"
        $0.font = AFFont.titleCard
    }
    
    private lazy var peopleCountLabel = UILabel().then {
        $0.text = "\(count) 명"
        $0.textAlignment = .center
        $0.font = AFFont.text?.withSize(16)
    }
    
    private lazy var minusButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.minus), for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
    }
    
    private lazy var plusButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.plus), for: .normal)
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
        count = count > 1 ? count - 1 : count
    }
    
    @objc
    private func plusCount() {
        count = count < 25 ? count + 1 : count
    }
    
    // MARK: - Helpers
    
    func configure(count: Int) {
        self.count = count
    }
    
    private func configureUI() {
        addSubviews(peopleCountTitleLabel,
                    peopleCountLabel,
                    minusButton,
                    plusButton)
        
        peopleCountTitleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(minusButton.snp.leading)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 3/4)
        }
        
        peopleCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(minusButton.snp.trailing)
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 1/12)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(peopleCountTitleLabel.snp.trailing)
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 1/12)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(peopleCountLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 1/12)
        }
    }
}
