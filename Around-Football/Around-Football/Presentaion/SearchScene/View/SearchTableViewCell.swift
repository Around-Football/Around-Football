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
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let searchImageView = UIImageView().then {
        $0.image = UIImage(named: AFIcon.searchItem)
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var fieldNameLabel = UILabel().then {
        $0.text = "구장 이름"
        $0.font = AFFont.text?.withSize(16)
    }
    
    var fieldAddressLabel = UILabel().then {
        $0.text = "구장 주소"
        $0.font = AFFont.text?.withSize(14)
        $0.textColor = AFColor.grayScale300
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
        fieldNameLabel.text = place.name
        fieldAddressLabel.text = place.address
    }
    
    private func configureUI() {
        
        self.addSubviews(searchImageView,
                         fieldNameLabel,
                         fieldAddressLabel)
        
        searchImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(fieldAddressLabel.snp.leading)
            make.height.equalTo(fieldNameLabel)
        }
        
        fieldNameLabel.snp.makeConstraints { make in
            make.top.equalTo(searchImageView)
            make.leading.equalTo(fieldAddressLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldNameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalTo(fieldNameLabel)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
        }
    }
}
