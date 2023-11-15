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
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
        $0.distribution = .fill
    }
    
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.spacing = 8
        $0.distribution = .fill
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
            contentStackView,
            infoStackView
        )
        
        updateAlarmLabelUI()
        
        contentStackView.addArrangedSubviews(
            chatRoomLabel,
            chatPreviewLabel
        )
        
        infoStackView.addArrangedSubviews(
            recentDateLabel,
            chatAlarmNumberLabel
        )
        
        contentStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(infoStackView).offset(5)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
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
