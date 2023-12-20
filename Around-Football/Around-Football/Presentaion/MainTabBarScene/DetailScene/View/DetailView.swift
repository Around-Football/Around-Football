//
//  DetailView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/24/23.
//

import UIKit

final class DetailView: UIView {
    
    // MARK: - Properties
    
    private var matchDayTitleLabel = UILabel().then {
        $0.text = "시간"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var matchDayLabel = UILabel().then {
        $0.text = "20:00 - 22:00"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
    }
    
    private var groundAddressTitleLabel = UILabel().then {
        $0.text = "주소"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var groundAddressLabel = UILabel().then {
        $0.text = "경기도 안산시 단원구 고잔동 707-2"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
    }
    
    private var recruitingTitleLabel = UILabel().then {
        $0.text = "모집인원"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var recruitingLabel = UILabel().then {
        $0.text = "0/2명"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 0
    }
    
    private var genderTitleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var genderLabel = UILabel().then {
        $0.text = "남성"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 0
    }
    
    private var gamePriceTitleLabel = UILabel().then {
        $0.text = "게임비"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var gamePriceLabel = UILabel().then {
        $0.text = "10,000원"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 0
    }
    
    private var contentTitleLabel = UILabel().then {
        $0.text = "상세내용"
        $0.font = AFFont.titleCard
        $0.textColor = AFColor.secondary
    }
    
    private var contentLabel = UILabel().then {
        $0.text = "실력 상관 없습니다!"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 0
    }
    
    private lazy var matchDateStackView = UIStackView().then {
        $0.addArrangedSubviews(matchDayTitleLabel,
                               matchDayLabel)
        $0.axis = .horizontal
        $0.spacing = 43
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var groundAddressStackView = UIStackView().then {
        $0.addArrangedSubviews(groundAddressTitleLabel,
                               groundAddressLabel)
        $0.axis = .horizontal
        $0.spacing = 43
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var recruitingStackView = UIStackView().then {
        $0.addArrangedSubviews(recruitingTitleLabel,
                               recruitingLabel)
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var genderStackView = UIStackView().then {
        $0.addArrangedSubviews(genderTitleLabel,
                               genderLabel)
        $0.axis = .horizontal
        $0.spacing = 43
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var gamePriceStackView = UIStackView().then {
        $0.addArrangedSubviews(gamePriceTitleLabel,
                               gamePriceLabel)
        $0.axis = .horizontal
        $0.spacing = 29
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.addArrangedSubviews(contentTitleLabel,
                               contentLabel)
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .top
        $0.distribution = .fill
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
    
    func formatMatchDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd (E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func setValues(item: Recruit) {
        let formattedCellDate = formatMatchDate(item.matchDate?.dateValue() ?? Date())
        
        matchDayLabel.text = item.title
        matchDayLabel.text = formattedCellDate
        groundAddressLabel.text = item.fieldAddress
        // TODO: - item에 추가되면 설정
        //        genderLabel.text = item.gender
        recruitingLabel.text = "\(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount)" + " 명"
        gamePriceLabel.text = item.gamePrice
        contentLabel.text = item.content
    }
    
    private func configureUI() {
        addSubviews(matchDateStackView,
                    groundAddressStackView,
                    recruitingStackView,
                    genderStackView,
                    gamePriceStackView,
                    contentStackView)
        matchDateStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        groundAddressStackView.snp.makeConstraints {
            $0.top.equalTo(matchDateStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        recruitingStackView.snp.makeConstraints {
            $0.top.equalTo(groundAddressStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(recruitingStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        gamePriceStackView.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(gamePriceStackView.snp.bottom).offset(16)
            $0.bottom.leading.equalToSuperview()
        }
    }
}
