//
//  DateCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

final class DateCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let cellID = "DateCell"
    
    var dateLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 12)
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

    private func configureUI() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
    }
}
