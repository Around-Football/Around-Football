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
        $0.textAlignment = .left
    }
    
    private let locationLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "어라운드 풋볼 경기장"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "풋살"
        $0.textColor = AFColor.white
        $0.font = AFFont.filterMedium
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let recruitedPeopleLabel = UILabel().then {
        $0.text = "0/2 모집"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "남성"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
        
    private let errorLabel = UILabel().then {
        $0.font = AFFont.text
        $0.text = "게시글을 확인할 수 없습니다."
        $0.textColor = AFColor.grayScale100
        $0.textAlignment = .center
    }
    
    private let loadingView = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
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
            typeLabel,
            titleLabel,
            locationLabel,
            recruitedPeopleLabel,
            genderLabel,
            errorLabel,
            loadingView
        )
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(recruit: Recruit) {
        titleLabel.text = recruit.matchDayAndStartTime
        //        self.imageView.image = recruit.image
        locationLabel.text = recruit.fieldName
        typeLabel.text = recruit.type
        typeLabel.backgroundColor = recruit.type == "축구" ? AFColor.soccor : AFColor.futsal
        recruitedPeopleLabel.text = "\(recruit.currentRecruitedNumber) 모집"
        //            genderLabel.text = "\(recruit.gender)"

    }
    
    func configureInfo(recruit: Recruit?) {
        loadingView.isHidden = true
        
        if let recruit = recruit {
            
            configure(recruit: recruit)

            imageView.snp.makeConstraints {
                $0.width.height.equalTo(80)
                $0.top.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().offset(-20)
            }
            
            typeLabel.snp.makeConstraints {
                $0.width.equalTo(34)
                $0.height.equalTo(20)
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.top.equalToSuperview().offset(26)
            }
            
            titleLabel.snp.makeConstraints {
                $0.centerY.equalTo(typeLabel.snp.centerY)
                $0.leading.equalTo(typeLabel.snp.trailing).offset(8)
            }
            
            locationLabel.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.top.equalTo(typeLabel.snp.bottom).offset(8)
            }
            
            recruitedPeopleLabel.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.top.equalTo(locationLabel.snp.bottom).offset(4)
            }
            
            let dividerView = createHDividerView()
            addSubview(dividerView)
            dividerView.snp.makeConstraints {
                $0.leading.equalTo(recruitedPeopleLabel.snp.trailing).offset(8)
                $0.centerY.equalTo(recruitedPeopleLabel.snp.centerY)
            }
            
            genderLabel.snp.makeConstraints {
                $0.leading.equalTo(dividerView.snp.trailing).offset(8)
                $0.centerY.equalTo(recruitedPeopleLabel.snp.centerY)
            }
        } else {
            errorLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    private func createHDividerView() -> UIView {
        return UIView().then {
            $0.backgroundColor = AFColor.grayScale300
            $0.snp.makeConstraints { make in
                make.width.equalTo(0.6)
                make.height.equalTo(10)
            }
        }
    }
}
