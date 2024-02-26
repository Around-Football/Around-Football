//
//  ChannelUserInfoView.swift
//  Around-Football
//
//  Created by 진태영 on 12/28/23.
//

import UIKit

import SnapKit

class ChannelUserInfoView: UIView {
    
    // MARK: - Properties
    
    private let userGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userAgeLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userAreaLabel = UILabel().then {
        $0.text = "지역"
        $0.textColor = AFColor.grayScale300
        $0.font = AFFont.filterRegular
    }
    
    private let userMainUsedFeetLabel = UILabel().then {
        $0.text = "주발"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let userPositionLabel = UILabel().then {
        $0.text = "포지션"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
        $0.numberOfLines = 1
    }
        
    private lazy var userDetailInfoStackView = UIStackView().then { view in
        let subViews = [userGenderLabel,
                        createHDividerView(),
                        userAgeLabel,
                        createHDividerView(),
                        userAreaLabel,
                        createHDividerView(),
                        userMainUsedFeetLabel,
                        createHDividerView(),
                        userPositionLabel]
        view.axis = .horizontal
        view.spacing = 6
        view.distribution = .fill
        
        subViews.forEach { label in
            view.addArrangedSubview(label)
        }
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
    func configure(channelInfo: ChannelInfo) {
        userGenderLabel.text = channelInfo.withUserGender
        userAgeLabel.text = channelInfo.withUserAge
        userAreaLabel.text = channelInfo.withUserArea
        userMainUsedFeetLabel.text = channelInfo.withUserMainUsedFeet
        userPositionLabel.text = channelInfo.withUserPosition.map { $0 }.joined(separator: " ")
    }
    
    private func configureUI() {
        addSubviews(userDetailInfoStackView)
        userDetailInfoStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
    }
    
    // TODO: - height 줄이기
    private func createHDividerView() -> UIView {
        return UIView().then {
            $0.backgroundColor = AFColor.grayScale300
            $0.snp.makeConstraints { make in
                make.width.equalTo(0.6)
                make.height.equalTo(10)
            }
        }
    }

}
