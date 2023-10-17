//
//  infoStackView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/10/23.
//

import UIKit

import SnapKit
import Then

class infoArrangedView: UIView {
    
    // MARK: - Properties

     var nameLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 15)
    }
    
     var contentLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 15)
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
    
    func setValues(name: String, content: String) {
        nameLabel.text = name
        contentLabel.text = content
    }
    
    func configureUI() {
        addSubviews(nameLabel, contentLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }

}