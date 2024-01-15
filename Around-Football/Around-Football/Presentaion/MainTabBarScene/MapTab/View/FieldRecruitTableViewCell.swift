//
//  FieldRecruitTableViewCell.swift
//  Around-Football
//
//  Created by 진태영 on 10/16/23.
//

import UIKit

import Then
import SnapKit

final class FieldRecruitTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let playTimeLabel = UILabel().then {
        $0.text = "00:00 - 11:00"
        $0.textAlignment = .center
    }
    
    private let recruitNumber = UILabel().then {
        $0.text = "0/2명"
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    lazy var chattingButton = UIButton().then {
        $0.backgroundColor = AFColor.secondary
        $0.setTitle("채팅하기", for: .normal)
        $0.setTitleColor(AFColor.white, for: .normal)
        $0.titleLabel?.font = AFFont.filterMedium
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
    
    func configureUI() {
        
        contentView.addSubviews(
            playTimeLabel,
            recruitNumber,
            chattingButton
        )
        
        playTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.trailing.equalTo(recruitNumber.snp.leading).offset(-10)
        }
        
        recruitNumber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        chattingButton.snp.makeConstraints { make in
            make.leading.equalTo(recruitNumber.snp.trailing).offset(50)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
    }
}
