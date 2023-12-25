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
        $0.image = UIImage(named: "DefaultRecruitImage")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = AFFont.titleCard
        $0.text = "Title"
    }
    
    private let dateLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.text = "0000년 0월 0일 00:00"
        $0.font = AFFont.titleCard
    }
    
    private let locationLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "어라운드 풋볼 경기장"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    private var typeLabel = UILabel().then {
        $0.text = "풋살"
        $0.textColor = AFColor.white
        $0.font = AFFont.filterMedium
        $0.textAlignment = .center
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.masksToBounds = true
    }
    
    private let errorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let loadingView = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    
    private lazy var titleHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 8
        $0.addArrangedSubviews(
            typeLabel,
            titleLabel
        )
    }
    
    private lazy var recruitInfoStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 4
        $0.addArrangedSubviews(
            titleHStack,
            dateLabel,
            locationLabel
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
            errorLabel,
            loadingView
        )
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureInfo(recruit: Recruit?) {
        loadingView.isHidden = true
        
        if let recruit = recruit {
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(80)
                $0.leading.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
            
            recruitInfoStack.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.centerY.equalToSuperview()
            }
            
            typeLabel.snp.makeConstraints {
                $0.width.equalTo(34)
                $0.height.equalTo(20)

            }
                        
            titleLabel.text = recruit.title
            //        self.imageView.image = recruit.image
            //            dateLabel.text = "일정: \(recruit.matchDateString!) \(recruit.startTime!) - \(recruit.endTime!)"
            locationLabel.text = "장소: \(recruit.fieldName)"
            typeLabel.text = recruit.type
            typeLabel.backgroundColor = recruit.type == "축구" ? AFColor.soccor : AFColor.futsal
            
        } else {
            errorLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalToSuperview()
            }
            errorLabel.text = "게시글을 확인할 수 없습니다."
        }
    }
}
