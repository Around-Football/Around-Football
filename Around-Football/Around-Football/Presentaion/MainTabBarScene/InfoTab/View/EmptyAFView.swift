//
//  EmptyView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class EmptyAFView: UIView {
    
    //각 case에 따른 멘트
    enum SettingTitle: String {
        case noApplicant = "신청자가"
        case bookmark = "관심있는 글이"
        case application = "신청한 글이"
        case written = "작성한 글이"
    }
    
    // MARK: - Properties
    
    private let emptylabel = UILabel().then {
        $0.text = "아직 신청한 글이 없어요!"
        $0.textAlignment = .center
        $0.font = AFFont.text
        $0.textColor = AFColor.grayScale100
    }
    
    private let footballImageView = UIImageView().then {
        $0.image = UIImage(named: AFIcon.footballImage)?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Lifecycles
    
    init(frame: CGRect = .zero, type: SettingTitle) {
        super.init(frame: frame)
        
        configureUI()
        setEmptyAFViewTitle(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setEmptyAFViewTitle(_ type: SettingTitle) {
        emptylabel.text = "아직 \(type.rawValue) 없어요!"
    }
    
    private func configureUI() {
        addSubviews(emptylabel,
                    footballImageView)
        
        emptylabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(footballImageView.snp.top).offset(-180)
        }
        
        footballImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(50)
        }
    }
}
