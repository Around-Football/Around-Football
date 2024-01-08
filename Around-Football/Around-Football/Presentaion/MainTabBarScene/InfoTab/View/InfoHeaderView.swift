//
//  InfoHeaderView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/26/23.
//

import UIKit

import SnapKit
import Then

// MARK: - 내 정보, 설정 아이콘 커스텀 헤더 뷰

final class InfoHeaderView: UIView {
    
    // MARK: - Properties
    
    var settingButtonActionHandler: (() -> Void)?
    
    private var titleLabel = UILabel().then {
        $0.text = "내 정보"
        $0.textAlignment = .left
        $0.font = AFFont.titleMedium
    }
    
    private lazy var settingButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(named: AFIcon.settingButton)
        $0.setImage(image, for: .normal)
        $0.tintColor = .label
        $0.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc
    private func settingButtonTapped() {
        print("DEBUG: settingButtonTapped")
        if let settingButtonActionHandler {
            settingButtonActionHandler()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(titleLabel,
                    settingButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
