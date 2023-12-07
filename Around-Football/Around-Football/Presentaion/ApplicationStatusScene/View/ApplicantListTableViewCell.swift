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

    // MARK: - Properties
    
    static let cellID = "ApplicantListTableViewCellID"
    var viewModel: ApplicantListViewModel?
    weak var vc: ApplicantListViewController?
    var uid: String?

    private var disposeBag = DisposeBag()

    private lazy var mainStackView = UIStackView().then {
        $0.addArrangedSubviews(profileImage,
                               userInfoStackView,
                               buttonStackView)
        $0.spacing = 15
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
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
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }

    private lazy var detailInfoStackView1 = UIStackView().then {
        $0.addArrangedSubviews(userAgeLabel,
                               createDotView(),
                               userGenderLabel,
                               createDotView(),
                               userAreaLabel)
        $0.spacing = 1
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let userAgeLabel = UILabel().then {
        $0.text = "나이"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    private let userGenderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    private let userAreaLabel = UILabel().then {
        $0.text = "지역"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    private lazy var detailInfoStackView2 = UIStackView().then {
        $0.addArrangedSubviews(userMainUsedFeetLabelLabel,
                               createDotView(),
                               userPositionLabel)
        $0.spacing = 1
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let userMainUsedFeetLabelLabel = UILabel().then {
        $0.text = "주발"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    private let userPositionLabel = UILabel().then {
        $0.text = "포지션"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }

    // TODO: - 버튼 addTarget
    private lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubviews(acceptButton,
                               rejectButton)
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .trailing
    }
    
    private lazy var acceptButton = UIButton().then {
        $0.setTitle("수락", for: .normal)
        $0.backgroundColor = .blue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    private lazy var rejectButton = UIButton().then {
        $0.setTitle("거절", for: .normal)
        $0.backgroundColor = .darkGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc
    private func acceptButtonTapped() {
        FirebaseAPI.shared.acceptApplicants(fieldID: viewModel?.recruitItem?.fieldID ?? "", userID: uid)
        vc?.acceptButtonTappedSubject.onNext((viewModel?.recruitItem?.fieldID, uid))
    }
    
    @objc
    private func rejectButtonTapped() {
        FirebaseAPI.shared.deleteApplicant(fieldID: viewModel?.recruitItem?.fieldID ?? "", userID: uid)
        vc?.rejectButtonTappedSubject.onNext((viewModel?.recruitItem?.fieldID, uid))
    }
    
    // MARK: - Helpers
    
    func bindUI(uid: String?) {
        FirebaseAPI.shared.fetchUser(uid: uid ?? "") { [weak self] user in
            guard let self else { return }
            userNameLabel.text = user.userName
            userAgeLabel.text = user.age
            userGenderLabel.text = user.gender
            userAreaLabel.text = user.area
            userMainUsedFeetLabelLabel.text = user.mainUsedFeet
            userPositionLabel.text = user.position.joined(separator: ", ")
        }
    }

    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(120).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        rejectButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
    }
    
    private func createDotView() -> UILabel {
        return UILabel().then {
            $0.text = "∙"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 10)
        }
    }
}
