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
    private let groundTitleLabel = UILabel().then {
        $0.text = "장소"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        config.imagePadding = 5
        return config
    }
    
    lazy var searchFieldButton: UIButton = {
        
        let button = UIButton(configuration: buttonConfig)
        let image = UIImage(systemName: "magnifyingglass")
        // 버튼 타이틀과 이미지 설정
        button.setTitle("장소를 검색해주세요.", for: .normal)
        button.setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                        for: .normal)
        // 버튼 스타일 설정
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = LayoutOptions.cornerRadious // 버튼의 모서리를 둥글게 만듭니다.
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
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
    
    private func configureUI() {
        addSubviews(groundTitleLabel, searchFieldButton)
        
        groundTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        searchFieldButton.snp.makeConstraints { make in
            make.top.equalTo(groundTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
    }
}
