//
//  infoCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/9/23.
//

import UIKit

final class InfoCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellID = "infoCell"
    
    private var titleLable = UILabel().then {
        $0.text = "타이틀"
        $0.font = AFFont.text
    }
    
    private let rightIcon = UIImageView(image: UIImage(named: AFIcon.rightButton))
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setValues(title: String) {
        titleLable.text = title
    }

    private func configureUI() {
        addSubviews(titleLable, rightIcon)
        
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
//            make.width.height.equalTo(24)
        }
    }
}
