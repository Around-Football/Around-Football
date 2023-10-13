//
//  HomeTableViewCell.swift
//  Around-Football
//
//  Created by 강창현 on 10/11/23.
//

import UIKit

import RxSwift
import RxCocoa
import Then
import SnapKit
/*
 1. Properties
 2. Lifecycles
 3. API
 4. Selectors
 5. Helpers
 */
class HomeTableViewCell: UITableViewCell {
    static let id: String = "HomeTableViewCell"
    
    var titleLabel = UILabel().then {
        $0.text = "Title Text"
    }
    
    var fieldAddress = UILabel().then {
        $0.text = "Field Address"
    }
    
    var dateLabel = UILabel().then {
        $0.text = "DateLabel"
    }
    
    var timeLabel = UILabel().then {
        $0.text = "TimeLabel"
    }
    
    var recruitLabel = UILabel().then {
        $0.text = "Recurit 0명"
    }
    
    var timelineStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 6
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubviews(titleLabel,
                                fieldAddress,
                                timelineStackView,
//                                dateLabel,
//                                timeLabel,
                                recruitLabel
        )
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        fieldAddress.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(30)
            make.leading.equalTo(titleLabel)
        }
        
        timelineStackView.addArrangedSubviews(dateLabel,
                                              timeLabel
        )
        
        timelineStackView.snp.makeConstraints { make in
            make.top.equalTo(fieldAddress).offset(30)
            make.leading.equalTo(titleLabel)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(timelineStackView).offset(30)
            make.leading.equalTo(titleLabel)
        }
    }
}
