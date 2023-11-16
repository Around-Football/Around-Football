//
//  SearchTableViewCell.swift
//  Around-Football
//
//  Created by 강창현 on 11/14/23.
//

import UIKit

import SnapKit
import Then

final class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellID: String = "SearchTableViewCell"
    
    var fieldNameLabel = UILabel().then {
        $0.text = "구장 이름"
    }
    
    var fieldAddressLabel = UILabel().then {
        $0.text = "구장 주소"
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
    
    func configureCell(with place: Place) {
        fieldNameLabel.text = place.address
        fieldAddressLabel.text = place.address
    }
    
    private func configureUI() {
        
        self.addSubviews(fieldNameLabel,
                         fieldAddressLabel)
        
        fieldNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(fieldNameLabel)
            make.trailing.equalTo(fieldNameLabel)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
}
