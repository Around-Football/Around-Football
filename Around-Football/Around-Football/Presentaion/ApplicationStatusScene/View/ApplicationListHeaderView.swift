//
//  ApplicationListHeaderView.swift
//  Around-Football
//
//  Created by 진태영 on 12/25/23.
//

import UIKit

class ApplicationListHeaderView: UIView {
    
    // MARK: - Properties
    
    private let typeLabel = UILabel().then {
        $0.text = "풋살"
        $0.backgroundColor = $0.text == "축구" ? AFColor.soccor : AFColor.futsal
        $0.textColor = AFColor.white
        $0.font = AFFont.text
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "12/15(금) 20:00"
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleMedium
    }
    
    private let groundLabel = UILabel().then {
        $0.text = "축구장 이름"
        $0.numberOfLines = 2
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleRegular
    }
    
    private let recruitingTitleLabel = UILabel().then {
        $0.text = "모집인원"
        $0.font = AFFont.button
        $0.textColor = AFColor.secondary
    }
    
    private let recruitingLabel = UILabel().then {
        $0.text = "0/2명"
        $0.font = AFFont.text
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 0
    }
    
    // MARK: - Lifecycles
    
    init() {
        super.init(frame: .zero)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(recruit: Recruit) {
        typeLabel.text = recruit.type
        dateLabel.text = "\(recruit.matchDayAndStartTime) \(recruit.startTime)"
        groundLabel.text = recruit.fieldName
        recruitingLabel.text = "\(recruit.acceptedApplicantsUID.count)"
        configureTypeLabel(recruit: recruit)
    }
    
    private func configureUI() {
        addSubviews(typeLabel,
                    dateLabel,
                    groundLabel,
                    recruitingTitleLabel,
                    recruitingLabel)
        typeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(51)
            make.height.equalTo(26)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel.snp.trailing).offset(12)
            make.top.equalToSuperview()
        }
        
        groundLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
        }
        
        recruitingTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(groundLabel.snp.bottom).offset(12)
        }
        
        recruitingLabel.snp.makeConstraints { make in
            make.leading.equalTo(recruitingTitleLabel.snp.trailing).offset(8)
            make.top.equalTo(groundLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureTypeLabel(recruit: Recruit) {
        typeLabel.text = recruit.type
        typeLabel.backgroundColor = recruit.type == "축구" ? AFColor.soccor : AFColor.futsal
    }
}
/*
 //
 //  ApplicationListHeaderView.swift
 //  Around-Football
 //
 //  Created by 진태영 on 12/25/23.
 //

 import UIKit

 class ApplicationListHeaderView: UIView {
     
     // MARK: - Properties
     
     private lazy var containerStackView = UIStackView().then {
         $0.axis = .vertical
         $0.spacing = 12
         $0.distribution = .equalSpacing
         $0.alignment = .leading
         $0.addArrangedSubviews(topLineStackView,
                                groundLabel,
                                bottomLineStackView)
     }
     
     private lazy var topLineStackView = UIStackView().then {
         $0.axis = .horizontal
         $0.spacing = 12
         $0.distribution = .fill
         $0.alignment = .center
         $0.addArrangedSubviews(typeLabel,
                                dateLabel)
     }
     
     private let typeLabel = UILabel().then {
         $0.text = "풋살"
         $0.textColor = AFColor.white
         $0.font = AFFont.text
         $0.textAlignment = .center
         $0.layer.cornerRadius = 4
         $0.layer.masksToBounds = true
     }
     
     private let dateLabel = UILabel().then {
         $0.text = "12/15(금) 20:00"
         $0.textColor = AFColor.secondary
         $0.font = AFFont.titleMedium
     }
     
     private let groundLabel = UILabel().then {
         $0.text = "축구장 이름"
         $0.numberOfLines = 2
         $0.textColor = AFColor.secondary
         $0.font = AFFont.titleRegular
     }
     
     private lazy var bottomLineStackView = UIStackView().then {
         $0.axis = .horizontal
         $0.spacing = 8
         $0.distribution = .fill
         $0.alignment = .center
         $0.addArrangedSubviews(recruitingTitleLabel,
                                recruitingLabel)
     }
     
     private let recruitingTitleLabel = UILabel().then {
         $0.text = "모집인원"
         $0.font = AFFont.button
         $0.textColor = AFColor.secondary
     }
     
     private let recruitingLabel = UILabel().then {
         $0.text = "0/2명"
         $0.font = AFFont.text
         $0.textColor = AFColor.secondary
         $0.numberOfLines = 0
     }
     
     // MARK: - Lifecycles
     
     init() {
         super.init(frame: .zero)
                 configureUI()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // MARK: - Helpers
     
 //    func configure(recruit: Recruit) {
 //        typeLabel.text = recruit.type
 //        dateLabel.text = "\(recruit.matchDayString) \(recruit.startTime)"
 //        groundLabel.text = recruit.fieldName
 //        recruitingLabel.text = "\(recruit.acceptedApplicantsUID.count)"
 //        configureTypeLabel(recruit: recruit)
 //    }
     
     private func configureUI() {
         addSubviews(containerStackView)
         
         containerStackView.snp.makeConstraints { make in
             make.edges.equalToSuperview()
         }
     }
     
     func configureTypeLabel(recruit: Recruit) {
         typeLabel.text = recruit.type
         typeLabel.backgroundColor = recruit.type == "축구" ? AFColor.soccor : AFColor.futsal
     }
 }

 */
