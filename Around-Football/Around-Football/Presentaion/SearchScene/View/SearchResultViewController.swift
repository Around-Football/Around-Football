//
//  SearchResultViewController.swift
//  Around-Football
//
//  Created by 강창현 on 11/14/23.
//

import UIKit

import SnapKit
import Then

class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    private var testTextLabel = UILabel().then {
        $0.text = "검색 결과 화면"
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(testTextLabel)
        
        testTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}

extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
