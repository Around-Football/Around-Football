//
//  FieldRecruitTableViewCell.swift
//  Around-Football
//
//  Created by 진태영 on 10/16/23.
//

import UIKit

import RxSwift
import Then
import SnapKit

final class FieldRecruitTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let matchDateLabel = UILabel().then {
        $0.text = "12/15(금)"
        $0.textAlignment = .center
        $0.font = AFFont.titleCard
    }
    
    private let playTimeLabel = UILabel().then {
        $0.text = "00:00"
        $0.textAlignment = .center
        $0.font = AFFont.text
    }
    
    private let recruitNumber = UILabel().then {
        $0.text = "0/2명"
        $0.textAlignment = .center
        $0.font = AFFont.text
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    private lazy var chattingButton = UIButton().then {
        $0.backgroundColor = AFColor.secondary
        $0.setTitle("채팅하기", for: .normal)
        $0.setTitleColor(AFColor.white, for: .normal)
        $0.titleLabel?.font = AFFont.filterMedium
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let myRecruitLabel = UILabel().then {
        $0.backgroundColor = AFColor.primary
        $0.text = "나의 공고"
        $0.textColor = AFColor.secondary
        $0.textAlignment = .center
        $0.font = AFFont.filterMedium
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(recruit: Recruit) {
        self.matchDateLabel.text = recruit.matchDate.dateValue().toString()
        self.playTimeLabel.text = recruit.startTime
        self.recruitNumber.text = "\(recruit.acceptedApplicantsUID.count)/\(recruit.recruitedPeopleCount)명"
    }
    
    func bindButton(disposeBag: DisposeBag, completion: @escaping () -> Void) {
        self.chattingButton.rx.tap
            .bind {
                completion()
            }.disposed(by: disposeBag)
    }
    
    func checkMyRecruit(result: Bool) {
        result ? stackView.addArrangedSubview(myRecruitLabel) : stackView.addArrangedSubview(chattingButton)
    }
    
    private func configureUI() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews(
            matchDateLabel,
            playTimeLabel,
            recruitNumber
        )
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
