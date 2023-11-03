//
//  DateFilterViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/20/23.
//

import UIKit

import SnapKit
import Then

final class DateFilterViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel().then { 
        $0.text = "찾고 싶은 날짜를 선택해주세요"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
    }
    
    // MARK: - Seletors
    
    
}
