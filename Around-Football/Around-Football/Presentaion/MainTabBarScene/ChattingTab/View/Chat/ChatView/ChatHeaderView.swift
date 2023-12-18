//
//  ChatHeaderView.swift
//  Around-Football
//
//  Created by 진태영 on 12/15/23.
//

import UIKit

import SnapKit
import Then

class ChatHeaderView: UIView {

    // MARK: - Properties
    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.text = "Title"
    }
    
    private let dateLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.text = "일정: 0000년 0월 0일 00:00 - 00:00"
    }
    
    private let locationLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "장소: 어라운드 풋볼 경기장"
    }
    
    private let typeLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.text = "유형: 풋살"
    }
    
    private let errorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private lazy var recruitInfoStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
        $0.addArrangedSubviews(
            titleLabel,
            dateLabel,
            locationLabel,
            typeLabel
        )
    }
    
    // MARK: - Lifecycles
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(
        imageView,
        recruitInfoStack,
        errorLabel
        )
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(45)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        recruitInfoStack.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configureInfo(recruit: Recruit?) {
        if let recruit = recruit {
            imageView.isHidden = false
            recruitInfoStack.isHidden = false
            errorLabel.isHidden = true
            titleLabel.text = recruit.title
            //        self.imageView.image = recruit.image
            dateLabel.text = "일정: \(recruit.matchDateString!) \(recruit.startTime!) - \(recruit.endTime!)"
            locationLabel.text = "장소: \(recruit.fieldName)"
            typeLabel.text = "유형: \(recruit.type)"
        } else {
            
        }
    }
    
    func configureErrorInfo() {
        imageView.isHidden = true
        recruitInfoStack.isHidden = true
        errorLabel.isHidden = false
        
        errorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }

        errorLabel.text = "게시글을 확인할 수 없습니다."
    }
}
