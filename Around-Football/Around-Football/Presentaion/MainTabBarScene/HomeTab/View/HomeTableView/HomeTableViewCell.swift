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
    
    private var titleLabel = UILabel().then {
        $0.text = "Title Text"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private var fieldLabel = UILabel().then {
        $0.text = "Field Text"
    }
    
    private var fieldAddress = UILabel().then {
        $0.text = "Field Address"
    }
    
    private var typeLabel = UILabel().then {
        $0.text = "Field Address"
        $0.textColor = AFColor.white
        $0.font = AFFont.filterMedium
        $0.textAlignment = .center
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.layer.masksToBounds = true
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "DateLabel"
    }
    
    private var recruitLabel = UILabel().then {
        $0.text = "Recurit 0명"
    }
    
    private var userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let defaultFieldImage = UIImage(named: AFIcon.fieldImage)
    private lazy var fieldImageView = UIImageView(image: defaultFieldImage)

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
    
    func bindContents(item: Recruit) {
        //cell에 사용할 id 세팅
        self.fieldID = item.fieldID
        //북마크 버튼 바인딩
        setBookmarkBinding(fieldID: item.fieldID)
        //UI정보 바인딩
        titleLabel.text = item.title
        fieldLabel.text = "필드: \(item.fieldName)"
        fieldAddress.text = "주소: \(item.fieldAddress)"
        typeLabel.text = item.type
        typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        dateLabel.text = "일정: \(item.matchDateString ?? "") \(item.startTime ?? "") - \(item.endTime ?? "")"
        recruitLabel.text = "모집 용병: \(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount) 명"
        userNameLabel.text = "\(item.userName)"
    }
    
    //북마크 버튼 세팅
    private func setBookmarkBinding(fieldID: String) {
        UserService.shared.currentUser_Rx
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.user = user
                isSelectedButton = user?.bookmarkedFields.filter { $0 == fieldID }.count != 0
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
                                userNameLabel,
                                bookmarkButton)
    
        fieldImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
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
        
//        userNameLabel.snp.makeConstraints { make in
//            make.top.equalTo(recruitLabel.snp.bottom).offset(5)
//            make.trailing.equalTo(snp.trailing).offset(SuperviewOffsets.trailingPadding)
//            make.bottom.equalToSuperview().offset(-10)
//        }
        
        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
//        }
        
//        bookmarkButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalTo(titleLabel.snp.trailing).offset(10).priority(.low)
//            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
//        }
        
        //        fieldAddress.snp.makeConstraints { make in
        //            make.top.equalTo(dateLabel.snp.bottom).offset(5)
        //            make.leading.equalTo(titleLabel)
        //            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        //        }
    }
}
