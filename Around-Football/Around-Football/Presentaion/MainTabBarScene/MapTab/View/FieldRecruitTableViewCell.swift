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
    
    static let cellID: String = "FieldRecruitTableViewCell"
    
    private let playTimeLabel = UILabel().then {
        $0.text = "00:00 ~ 11:00"
    }
    
    private let recruitNumber = UILabel().then {
        $0.text = "용병 10명"
    }
    
    lazy var applyButton = UIButton().then {
        $0.configuration = .filled()
        $0.setTitle("지원하기", for: .normal)
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
        let view = UIView()
        view.addSubview(recruitNumber)
        
        self.addSubviews(
            playTimeLabel,
            view,
            applyButton
        )
        
        playTimeLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(92)
            $0.height.equalTo(32)
        }
        
        view.snp.makeConstraints {
            $0.leading.equalTo(playTimeLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        recruitNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
