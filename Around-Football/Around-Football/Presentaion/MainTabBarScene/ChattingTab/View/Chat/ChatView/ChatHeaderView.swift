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
        recruitInfoStack
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
    
    func configureInfo(recruit: Recruit) {
        self.titleLabel.text = recruit.title
//        self.imageView.image = recruit.image
        self.dateLabel.text = "일정: \(recruit.matchDateString!) \(recruit.startTime!) - \(recruit.endTime!)"
        self.locationLabel.text = "장소: \(recruit.fieldName)"
        self.typeLabel.text = "유형: \(recruit.type)"
    }
    
    func configureErrorInfo() {
        self.titleLabel.text = "게시글을 확인할 수 없습니다."
        self.dateLabel.text = ""
        self.imageView.image = nil
        self.locationLabel.text = ""
        self.typeLabel.text = ""
    }
}
