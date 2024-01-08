//
//  ImageView.swift
//  Around-Football
//
//  Created by 강창현 on 1/3/24.
//

import UIKit

import SnapKit
import Then

class InviteImageView: UIImageView {
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.deleteButton), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
    }
}
