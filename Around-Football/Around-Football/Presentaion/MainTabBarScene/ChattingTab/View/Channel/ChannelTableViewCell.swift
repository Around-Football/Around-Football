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
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "DefaultProfileImage")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleSmall
        $0.numberOfLines = 1
        $0.text = "Name"
    }
    
    private let recentDateLabel = UILabel().then {
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
        $0.numberOfLines = 1
        $0.text = "00월 00일"
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let chatPreviewLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.text = "Preview"
    }
    
    private lazy var chatAlarmNumberLabel = UILabel().then {
        $0.textColor = AFColor.secondary
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.backgroundColor = AFColor.primary
        $0.text = "000"
        $0.layer.masksToBounds = true
    }
    
    private let upperStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let userDetailInfoView = ChannelUserInfoView()
        
    private let underStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
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
    
//    // TODO: - 지우기
//    func configure(channelInfo: ChannelInfo) {
//        userNameLabel.text = channelInfo.withUserName
//        chatPreviewLabel.text = channelInfo.previewContent
//        recentDateLabel.text = formatDate(channelInfo.recentDate)
//        configureAlarmLabelText(alarmNumber: channelInfo.alarmNumber)
//        updateAlarmLabelUI()
//    }
//        
    func configure(channelInfo: ChannelInfo) {
        channelInfo.downloadURL != nil ? (profileImageView.image = channelInfo.image) : (profileImageView.image = UIImage(systemName: "person"))
        
        userNameLabel.text = channelInfo.withUserName
        chatPreviewLabel.text = channelInfo.previewContent
        recentDateLabel.text = formatDate(channelInfo.recentDate)
        userDetailInfoView.configure(channelInfo: channelInfo)
        configureAlarmLabelText(alarmNumber: channelInfo.alarmNumber)
        updateAlarmLabelUI()
    }

    private func configureUI() {
        addSubviews(
            profileImageView,
            upperStackView,
            userDetailInfoView,
            underStackView
        )
        
        updateAlarmLabelUI()
        
        upperStackView.addArrangedSubviews(
            userNameLabel,
            recentDateLabel
        )
        
        underStackView.addArrangedSubviews(
            chatPreviewLabel,
            chatAlarmNumberLabel
        )
        
        recentDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        upperStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        upperStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        userDetailInfoView.snp.makeConstraints {
            $0.top.equalTo(upperStackView.snp.bottom).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        underStackView.snp.makeConstraints {
            $0.top.equalTo(userDetailInfoView.snp.bottom).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.bottom.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func updateAlarmLabelUI() {
        chatAlarmNumberLabel.snp.updateConstraints {
            let size = setTextLabelSize(label: chatAlarmNumberLabel)
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
            chatAlarmNumberLabel.layer.cornerRadius = size.height / 2
            
        }
    }
    
    private func configureAlarmLabelText(alarmNumber: Int) {
        var alarmString = ""
        alarmNumber > 999 ? (alarmString = "999+") : (alarmString = "\(alarmNumber)")
        if alarmNumber == 0 { alarmString = "" }
        
        alarmString == "" ? (chatAlarmNumberLabel.isHidden = true) : (chatAlarmNumberLabel.isHidden = false)
        chatAlarmNumberLabel.text = alarmString
    }
    
    private func setTextLabelSize(label: UILabel) -> CGSize {
        let size = (label.text as NSString?)?.size() ?? .zero
        let addWidthValue = 20 - 6.673828125
        let newSize = CGSize(width: size.width + addWidthValue, height: 20)
        return newSize
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "a h:mm"
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "M월 d일"
        } else {
            formatter.dateFormat = "yyyy년 M월 d일"
        }
        return formatter.string(from: date)
    }

}
