//
//  ApplicationStatusTableViewCell.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class ApplicantListTableViewCell: UITableViewCell {
    
    typealias ApplicantStatus = ApplicantListViewModel.ApplicantStatus
    
    // MARK: - Properties
    
    static let cellID = "ApplicantListTableViewCellID"
    
    private var disposeBag = DisposeBag()
    
    private lazy var containerStackView = UIStackView().then {
        $0.addArrangedSubviews(userProfileInfoStackView,
                               buttonStackView)
        $0.axis = .horizontal
        $0.distribution = .equalCentering
    }
    
    private lazy var userProfileInfoStackView = UIStackView().then {
        $0.addArrangedSubviews(profileImage,
                               userInfoStackView)
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "AFFieldImage")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    
    private lazy var userInfoStackView = UIStackView().then {
        $0.addArrangedSubviews(userNameLabel,
                               detailInfoStackView1,
                               detailInfoStackView2)
        $0.spacing = 1
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = AFFont.titleSmall
        $0.textColor = AFColor.secondary
        $0.numberOfLines = 1
    }
    
    private lazy var detailInfoStackView1 = UIStackView().then {
        $0.addArrangedSubviews(userAgeLabel,
                               createHDividerView(),
                               userGenderLabel,
                               createHDividerView(),
                               userAreaLabel)
        $0.spacing = 6
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let userAgeLabel = UILabel().then {
        $0.text = "나이"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let userGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let userAreaLabel = UILabel().then {
        $0.text = "지역"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private lazy var detailInfoStackView2 = UIStackView().then {
        $0.addArrangedSubviews(userMainUsedFeetLabel,
                               createHDividerView(),
                               userPositionLabel)
        $0.spacing = 6
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let userMainUsedFeetLabel = UILabel().then {
        $0.text = "주발"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let userPositionLabel = UILabel().then {
        $0.text = "포지션"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubviews(sendMessageButton,
                               acceptButton)
        $0.spacing = 4
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    let sendMessageButton = AFSmallButton(buttonTitle: "채팅하기",
                                          color: AFColor.secondary,
                                          font: AFFont.filterMedium)
    let acceptButton = AFSmallButton(buttonTitle: "수락하기", color: .white, font: AFFont.filterMedium).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = AFColor.secondary.cgColor
    }
    
    
    // MARK: - Lifecycles
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, viewModel: ApplicantListViewModel, uid: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
            
    // MARK: - Helpers
    
    func configure(user: User) {
        userNameLabel.text = user.userName
        userGenderLabel.text = user.gender
        userAgeLabel.text = String(user.age)
        userAreaLabel.text = user.area
        userMainUsedFeetLabel.text = user.mainUsedFeet
        userPositionLabel.text = user.position.map { $0 }.joined(separator: " ")
    }
    
    func setButtonStyle(status: ApplicantStatus) {
        acceptButton.isEnabled = status == .close ? false : true
        acceptButton.setTitle(status.statusDescription, for: .normal)
        acceptButton.setTitleColor(status == .accepted ? .white : AFColor.secondary, for: .normal)
        acceptButton.setBackgroundColor(status == .accepted ? AFColor.grayScale200 : .white, for: .normal)
        acceptButton.setBackgroundColor(status == .close ? .white : AFColor.grayScale200, for: .disabled)
        acceptButton.setTitleColor(status == .close ? AFColor.grayScale200 : .white, for: .disabled)
        acceptButton.layer.borderWidth = status == .accepted ? 0 : 1
        acceptButton.layer.borderColor = status == .close ? AFColor.grayScale100.cgColor : AFColor.secondary.cgColor
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
                
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
                
        sendMessageButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(72)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(72)
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
