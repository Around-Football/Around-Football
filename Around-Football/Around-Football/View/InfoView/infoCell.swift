//
//  infoCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/9/23.
//

import UIKit

class infoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let cellID = "infoCell"
    
    private let icon = UIImageView().then {
        $0.tintColor = .label
    }
    
    private var title = UILabel().then {
        $0.text = "관심 글"
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
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
        addSubviews(icon, title)
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
    }
    
    func setValues(icon: String, title: String) {
        self.icon.image = UIImage(systemName: icon)
        self.title.text = title
    }
    
}
