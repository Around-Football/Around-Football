//
//  ChannelTableViewCell.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import UIKit

import SnapKit
import Then

final class ChannelTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId: String = "ChannelTableViewCell"
    
    // MARK: - Lifecycles
    
    lazy var chatRoomLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 1
        $0.text = "default"
    }
    
    let recentDateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 1
        $0.text = "00월 00일"
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    let chatPreviewLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.text = "오오옹"
    }
    
    lazy var chatAlarmNumberLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.backgroundColor = .systemRed
        $0.text = "000"
        $0.layer.masksToBounds = true
    }
    
    let upperStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let underStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .top
        $0.spacing = 5
        $0.distribution = .fill
//        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    
    private func configureUI() {
        addSubviews(
            upperStackView,
            underStackView
        )
        
        updateAlarmLabelUI()
        
        upperStackView.addArrangedSubviews(
            chatRoomLabel,
            recentDateLabel
        )
        
        recentDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        underStackView.addArrangedSubviews(
            chatPreviewLabel,
            chatAlarmNumberLabel
        )
        
        upperStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        upperStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        underStackView.snp.makeConstraints {
            $0.top.equalTo(upperStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
//            $0.top.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func updateAlarmLabelUI() {
        chatAlarmNumberLabel.snp.updateConstraints {
            let size = setTextLabelSize(label: chatAlarmNumberLabel)
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
            chatAlarmNumberLabel.layer.cornerRadius = size.height / 2
            
        }
    }
    
    private func setTextLabelSize(label: UILabel) -> CGSize {
        let size = (label.text as NSString?)?.size() ?? .zero
        let newSize = CGSize(width: size.width + 15, height: size.height + 10)
        return newSize
    }
}
