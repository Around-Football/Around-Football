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
    
    // MARK: - Properties
    
    private let groundTitleLabel = UILabel().then {
        $0.text = "장소"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private lazy var groundNameLabel = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("장소를 검색해주세요.", for: .normal)
        $0.addTarget(self, action: #selector(searchFieldButtonTapped), for: .touchUpInside)
        // $0.font = .systemFont(ofSize: 15, weight: .regular)
        // $0.numberOfLines = 0
    }
    
    // MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
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
    
    // MARK: - Selectors
    
    @objc
    func searchFieldButtonTapped() {
        
    }
}
