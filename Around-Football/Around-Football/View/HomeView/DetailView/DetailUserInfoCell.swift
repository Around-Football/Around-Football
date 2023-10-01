//
//  DetailUserInfoCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import SnapKit
import Then

final class DetailUserInfoCell: UITableViewCell {
    static let cellID = "DetailUserInfoCell"
    
    var title = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    var contents = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        addSubview(title)
        addSubview(contents)
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(50)
        }
        
        contents.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(title.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
        }
    }

    
}
