//
//  GroundTitleView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

final class GroundTitleView: UIView {
    
    private let groundTitleLabel = UILabel().then {
        $0.text = "장소"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    var groundNameLabel = UILabel().then {
        $0.text = "종합운동장"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(groundTitleLabel, groundNameLabel)
        
        groundTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        groundNameLabel.snp.makeConstraints { make in
            make.top.equalTo(groundTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
    }
}
