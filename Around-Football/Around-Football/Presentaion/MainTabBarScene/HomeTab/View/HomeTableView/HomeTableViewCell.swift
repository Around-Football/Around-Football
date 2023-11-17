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
final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let id: String = "HomeTableViewCell"
    
    var titleLabel = UILabel().then {
        $0.text = "Title Text"
        $0.font = .boldSystemFont(ofSize: 20)
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
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func bindContents(item: Recruit) {
        self.titleLabel.text = "(장소) \(item.userName)"
        self.dateLabel.text = "(날짜) \(item.matchDate)"
        self.fieldAddress.text = "(주소) \(item.fieldID)"
        self.recruitLabel.text = "(용병 수) \(item.recruitedPeopleCount) 명"
        self.timeLabel.text = "\(item.startTime)"
    }
    
    private func configureUI() {
        contentView.addSubviews(titleLabel,
                                fieldAddress,
                                timelineStackView,
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
                                              timeLabel)
        
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
