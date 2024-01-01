//
//  HomeTableViewCell.swift
//  Around-Football
//
//  Created by 강창현 on 10/11/23.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import SnapKit

final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let id: String = "HomeTableViewCellID"
    var viewModel: HomeViewModel?
    private var user = try? UserService.shared.currentUser_Rx.value()
    private var disposeBag = DisposeBag()
    private var fieldID: String?
    private var isSelectedButton: Bool?

    private let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    
    private let defaultFieldImage = UIImage(named: AFIcon.fieldImage)
    private lazy var fieldImageView = UIImageView(image: defaultFieldImage)
    
    private var typeLabel = UILabel().then {
        $0.text = "축구"
        $0.textColor = AFColor.white
        $0.font = AFFont.filterMedium
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "DateLabel"
        $0.font = AFFont.titleCard
    }
    
    private var fieldLabel = UILabel().then {
        $0.text = "Field Text"
        $0.font = AFFont.titleSmall
        $0.numberOfLines = 2
    }
    
    private var recruitLabel = UILabel().then {
        $0.text = "2/2명 모집"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    private let line = UIView().then {
        $0.backgroundColor = AFColor.grayScale300
    }
    
    private var genderLabel = UILabel().then {
        $0.text = "성별 무관"
        $0.font = AFFont.filterRegular
        $0.textColor = AFColor.grayScale300
    }
    
    // MARK: - 예전 디자인 코드
    
    private var titleLabel = UILabel().then {
        $0.text = "Title Text"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private var fieldAddress = UILabel().then {
        $0.text = "Field Address"
    }
    
    private var userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func setSelectedBookmarkButton() {
        bookmarkButton.setImage(UIImage(systemName: "star.fill", withConfiguration: symbolConfiguration)?
            .withTintColor(.systemYellow, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func setNormalBookmarkButton() {
        bookmarkButton.setImage(UIImage(systemName: "star", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 셀이 재사용될 때 disposeBag 초기화
    }
    
    // MARK: - Helpers
    //버튼 탭
    func configureButtonTap() {
        guard let user = user else { return }
        
        bookmarkButton.rx.tap
            .map { [weak self] in
                guard let self else { return false }
                if isSelectedButton == true {
                    //북마크 해제 메서드
                    setNormalBookmarkButton()
                    //북마크 삭제
                    viewModel?.removeBookmark(uid: user.id, fieldID: fieldID)
                    return false
                } else {
                    //북마크 추가 메서드
                    setSelectedBookmarkButton()
                    //북마크 추가
                    viewModel?.addBookmark(uid: user.id, fieldID: fieldID)
                    return true
                }
            }
            .subscribe(onNext: { [weak self] bool in
                guard let self else { return }
                isSelectedButton = bool
            })
            .disposed(by: disposeBag)
    }
    
    func formatMatchDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd (E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func bindContents(item: Recruit) {
        let date = item.matchDate.dateValue()
        let formattedCellDate = formatMatchDate(date)
        
        //cell에 사용할 id 세팅
        self.fieldID = item.fieldID
        //북마크 버튼 바인딩
        setBookmarkBinding(fieldID: item.fieldID)
        //UI정보 바인딩

        if item.acceptedApplicantsUID.count == item.recruitedPeopleCount {
            typeLabel.text = "마감"
            typeLabel.backgroundColor = AFColor.grayScale200
        } else {
            typeLabel.text = item.type
            typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        }

        dateLabel.text = formattedCellDate
        fieldLabel.text = "\(item.fieldName)"
        recruitLabel.text = " \(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount)명 모집"
        
        //TODO: - 성별 input 추가되면 바인딩하기
//        genderLabel.text = ""
        
        // MARK: - 예전 디자인 코드
        titleLabel.text = item.title
        fieldAddress.text = "주소: \(item.fieldAddress)"
        userNameLabel.text = "\(item.userName)"
    }
    
    //북마크 버튼 세팅
    private func setBookmarkBinding(fieldID: String) {
        UserService.shared.currentUser_Rx
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.user = user
                isSelectedButton = user?.bookmarkedRecruit.filter { $0 == fieldID }.count != 0
                ? true : false
                setupBookmarkButton()
            }).disposed(by: disposeBag)
    }
    
    private func setupBookmarkButton() {
        if isSelectedButton == true {
            setSelectedBookmarkButton()
        } else {
            setNormalBookmarkButton()
        }
    }
    
    private func configureUI() {
        contentView.addSubviews(fieldImageView,
                                titleLabel,
                                fieldLabel,
                                fieldAddress,
                                dateLabel,
                                typeLabel,
                                recruitLabel,
                                line,
                                genderLabel)
    
        fieldImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(80)
        }

        typeLabel.snp.makeConstraints { make in
            make.width.equalTo(34)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(fieldImageView.snp.trailing).offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.top)
            make.leading.equalTo(typeLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        fieldLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.leading.equalTo(typeLabel.snp.leading)
            make.trailing.equalToSuperview()
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldLabel.snp.bottom).offset(8)
            make.leading.equalTo(typeLabel.snp.leading)
        }
        
        line.snp.makeConstraints { make in
            make.centerY.equalTo(recruitLabel.snp.centerY)
            make.height.equalTo(recruitLabel.snp.height)
            make.width.equalTo(1)
            make.leading.equalTo(recruitLabel.snp.trailing).offset(8)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitLabel.snp.centerY)
            make.height.equalTo(recruitLabel.snp.height)
            make.leading.equalTo(line.snp.trailing).offset(8)
        }
    }
}
