//
//  GroundTitleView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

final class GroundTitleView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: InviteViewModel?
    private let address = UITextView()
    private let groundTitleLabel = UILabel().then {
        $0.text = "장소"
        $0.font = AFFont.titleCard
        $0.sizeToFit()
    }
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        config.imagePadding = 5
        config.titleAlignment = .leading
        return config
    }
    
    lazy var searchFieldButton: UIButton = {
        let button = UIButton(configuration: buttonConfig)
        let image = UIImage(systemName: "magnifyingglass")
        button.setTitle("장소를 검색해주세요.", for: .normal)
        button.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = LayoutOptions.cornerRadious
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = AFColor.grayScale200.cgColor
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    
    // MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(fieldTitle: String) {
        searchFieldButton.setTitle(fieldTitle, for: .normal)
        searchFieldButton.setTitleColor(AFColor.grayScale400, for: .normal)
    }
    
    private func configureUI() {
        addSubviews(groundTitleLabel, searchFieldButton)
        
        groundTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        searchFieldButton.snp.makeConstraints { make in
            make.top.equalTo(groundTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
