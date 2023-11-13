//
//  GroundTitleView.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

protocol GroundTitleViewDelegate: AnyObject {
    func searchBarTapped()
}

final class GroundTitleView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: GroundTitleViewDelegate?
    private var viewModel: MapViewModel?
    private let groundTitleLabel = UILabel().then {
        $0.text = "장소"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    let searchFieldBar = UISearchBar().then {
        $0.placeholder = "장소를 검색해주세요."
        $0.searchBarStyle = .minimal
    }
    let searchFieldButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("장소를 검색해주세요.", for: .normal)
        // $0.font = .systemFont(ofSize: 15, weight: .regular)
        // $0.numberOfLines = 0
    }
    
    // MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(groundTitleLabel, searchFieldBar)
        
        groundTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
        }
        
        searchFieldBar.snp.makeConstraints { make in
            make.top.equalTo(groundTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
        }
    }
    
    private func setupSearchBar() {
        searchFieldBar.delegate = self
    }
}

extension GroundTitleView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate?.searchBarTapped()
        return false
    }
}
