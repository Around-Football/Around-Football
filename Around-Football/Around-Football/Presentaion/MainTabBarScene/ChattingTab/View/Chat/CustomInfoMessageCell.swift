//
//  CustomInfoMessageCell.swift
//  Around-Football
//
//  Created by 진태영 on 12/6/23.
//

import UIKit

import SnapKit
import Then

final class CustomInfoMessageCell: UICollectionViewCell {
    
    static let cellId = "DateMessageCell"
    
    let dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 10)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
