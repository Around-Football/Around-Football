//
//  DetailView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/24/23.
//

import UIKit

final class DetailView: UIView {

    // MARK: - Properties
    
    private var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "제목"
        $0.textColor = .gray
    }
    
    private var title = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "제목"
        $0.textColor = .gray
    }
    
    private var matchDayTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "일시"
        $0.textColor = .gray
    }
    
    private var matchDayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private var typeTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "유형"
        $0.textColor = .gray
    }
    
    private var typeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private var recruitingTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "모집인원"
        $0.textColor = .gray
    }
    
    private var recruitingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private var gamePriceTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "게임비"
        $0.textColor = .gray
    }
    
    private var gamePriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private var contentTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.text = "코멘트"
        $0.textColor = .gray
    }
    
    private var contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
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
    
    //TODO: - 제목, 타입, price 추가하고 업데이트
    func setValues(item: Recruit) {
        title.text = "제목" /*item.title*/
        matchDayLabel.text = item.matchDateString
        typeLabel.text = "풋살" //item.type
        recruitingLabel.text = String(item.recruitedPeopleCount)
        gamePriceLabel.text = "10,000원" //item.gamePrice
        contentLabel.text = item.content
    }
    
    private func configureUI() {
        addSubviews(titleLabel,
                    title,
                    matchDayTitleLabel,
                    matchDayLabel,
                    typeTitleLabel,
                    typeLabel,
                    recruitingTitleLabel,
                    recruitingLabel,
                    gamePriceTitleLabel,
                    gamePriceLabel,
                    contentTitleLabel,
                    contentLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        matchDayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        matchDayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(matchDayTitleLabel.snp.centerY)
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.equalTo(matchDayTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        typeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(matchDayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(typeTitleLabel.snp.centerY)
            make.top.equalTo(matchDayLabel.snp.bottom).offset(20)
            make.leading.equalTo(typeTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        recruitingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        recruitingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitingTitleLabel.snp.centerY)
            make.top.equalTo(typeLabel.snp.bottom).offset(20)
            make.leading.equalTo(recruitingTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        gamePriceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
        }
        
        gamePriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gamePriceTitleLabel.snp.centerY)
            make.top.equalTo(recruitingLabel.snp.bottom).offset(20)
            make.leading.equalTo(gamePriceTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(gamePriceLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
            make.width.equalTo(60)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentTitleLabel.snp.centerY)
            make.top.equalTo(gamePriceLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
