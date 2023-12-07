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

final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let id: String = "HomeTableViewCell"
    var isButtonSelected = false
    var disposeBag = DisposeBag()
    
    private var titleLabel = UILabel().then {
        $0.text = "Title Text"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private var fieldLabel = UILabel().then {
        $0.text = "Field Text"
    }
    
    private var fieldAddress = UILabel().then {
        $0.text = "Field Address"
    }
    
    private var typeLabel = UILabel().then {
        $0.text = "Field Address"
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "DateLabel"
    }
    
    private var recruitLabel = UILabel().then {
        $0.text = "Recurit 0명"
    }
    
    private var userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    lazy var bookmarkButton = UIButton().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        $0.setImage(UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
    }
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isButtonSelected = false
        bookmarkButton.isSelected = false
    }
    
    // MARK: - Helpers
    //버튼 탭
    func setupBookmarkButtonAction() {
        isButtonSelected.toggle()
        
        if isButtonSelected {
            bookmarkButton.isSelected = true
            //눌렀을때 user에 북마크 fieldID 추가
        } else {
            bookmarkButton.isSelected = false
            //눌렀을때 user에 북마크 fieldID 삭제
        }
    }
    
    func bindContents(item: Recruit) {
        titleLabel.text = item.title
        fieldLabel.text = "필드: \(item.fieldName)"
        fieldAddress.text = "주소: \(item.fieldAddress)"
        typeLabel.text = "유형: \(item.type)"
        dateLabel.text = "일정: \(item.matchDateString ?? "") \(item.startTime ?? "") - \(item.endTime ?? "")"
        recruitLabel.text = "모집 용병: \(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount) 명"
        userNameLabel.text = "\(item.userName)"
    }
    
    private func configureUI() {
        contentView.addSubviews(titleLabel,
                                fieldLabel,
                                fieldAddress,
                                dateLabel,
                                typeLabel,
                                recruitLabel,
                                userNameLabel,
                                bookmarkButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10).priority(.low)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldAddress.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldAddress.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitLabel.snp.bottom).offset(5)
            make.trailing.equalTo(snp.trailing).offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension Reactive where Base: HomeTableViewCell {
    var bookmarkButtonTapped: ControlEvent<Void> { base.bookmarkButton.rx.tap }
}
