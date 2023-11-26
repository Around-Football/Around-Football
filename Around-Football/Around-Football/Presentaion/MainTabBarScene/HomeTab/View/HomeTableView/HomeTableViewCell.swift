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
    
    var recruitLabel = UILabel().then {
        $0.text = "Recurit 0명"
    }
    
    var userNameLabel = UILabel().then {
        $0.text = "Recurit 0명"
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
        self.titleLabel.text = item.title
        self.fieldAddress.text = "주소: \(item.fieldAddress)"
        self.dateLabel.text = "일정: \(item.matchDateString ?? "")  \(item.startTime ?? "") - \(item.endTime ?? "")"
        self.recruitLabel.text = "모집 용병: \(item.recruitedPeopleCount) 명"
        self.userNameLabel.text = "by. \(item.userName)"
    }
    
    private func configureUI() {
        contentView.addSubviews(titleLabel,
                                fieldAddress,
                                dateLabel,
                                recruitLabel,
                                userNameLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldAddress.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldAddress.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
