//
//  DetailView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/24/23.
//

import UIKit

final class DetailView: UIView {
//    let cellTitles = ["일시", "유형", "모집", "게임비", "내용"]
    
    // MARK: - Properties
    
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
        $0.text = "모집"
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
        $0.text = "내용"
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
    
    func setValues(
        matchDay: String?,
        type: String?,
        recruitingCount: Int?,
        gamePrice: String?,
        content: String?
    ) {
        matchDayLabel.text = matchDay
        typeLabel.text = type
        recruitingLabel.text = String(recruitingCount ?? 0)
        gamePriceLabel.text = gamePrice
        contentLabel.text = content
    }
    
    private func configureUI() {
        addSubviews(matchDayTitleLabel,
                    matchDayLabel,
                    typeTitleLabel,
                    typeLabel,
                    recruitingTitleLabel,
                    recruitingLabel,
                    gamePriceTitleLabel,
                    gamePriceLabel,
                    contentTitleLabel,
                    contentLabel)
        
        matchDayTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.width.equalTo(50)
        }
        
        matchDayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(matchDayTitleLabel.snp.centerY)
            make.leading.equalTo(matchDayTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        typeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(matchDayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(50)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(typeTitleLabel.snp.centerY)
            make.leading.equalTo(typeTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        recruitingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(50)
        }
        
        recruitingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitingTitleLabel.snp.centerY)
            make.leading.equalTo(recruitingTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        gamePriceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalTo(50)
        }
        
        gamePriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gamePriceTitleLabel.snp.centerY)
            make.leading.equalTo(gamePriceTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
        }
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(gamePriceLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
            make.width.equalTo(50)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentTitleLabel.snp.centerY)
            make.leading.equalTo(contentTitleLabel.snp.trailing).offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
