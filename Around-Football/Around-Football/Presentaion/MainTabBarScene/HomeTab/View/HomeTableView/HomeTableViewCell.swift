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
    private let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    private var user = try? UserService.shared.currentUser_Rx.value()
    private var fieldID: String?
    var isSelectedButton: Bool?
    var disposeBag = DisposeBag()
    
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

    lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func setSelectedBookmarkButton() {
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func setNormalBookmarkButton() {
        bookmarkButton.setImage(UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?
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
        print("prepareForReuse")
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
                    setNormalBookmarkButton()
                    //북마크 해제 메서드
                    print("버튼 해제하기")
                    //북마크 삭제
                    FirebaseAPI.shared.fetchUser(uid: user.id) { user in
                        var user = user
                        var bookmark = user.bookmarkedFields
                        bookmark.removeAll { fieldID in
                            self.fieldID == fieldID
                        }
                        user.bookmarkedFields = bookmark
                        FirebaseAPI.shared.updateUser(user)
                    }
                    
                    return false
                } else {
                    print("버튼 누르기")
                    //북마크 추가 메서드
                    setSelectedBookmarkButton()
                    //북마크 추가
                    FirebaseAPI.shared.fetchUser(uid: user.id) { user in
                        var user = user
                        var bookmark = user.bookmarkedFields
                        bookmark.append(self.fieldID)
                        user.bookmarkedFields = bookmark
                        FirebaseAPI.shared.updateUser(user)
                    }
                    
                    return true
                }
            }
            .subscribe(onNext: { [weak self] bool in
                guard let self else { return }
                isSelectedButton = bool
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBookmarkButton() {
        if isSelectedButton == true {
            setSelectedBookmarkButton()
            print("버튼 눌린 상태")
        } else {
            setNormalBookmarkButton()
            print("버튼 안 눌린 상태")
        }
    }
    
    func bindContents(item: Recruit) {
        //cell에 사용할 id 세팅
        self.fieldID = item.fieldID
        
        //북마크 버튼 바인딩
        UserService.shared.currentUser_Rx
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.user = user
                isSelectedButton = user?.bookmarkedFields.filter { $0 == item.fieldID }.count != 0
                ? true : false
                setupBookmarkButton()
            }).disposed(by: disposeBag)
        
        titleLabel.text = item.title
        fieldLabel.text = "필드: \(item.fieldName)"
        fieldAddress.text = "주소: \(item.fieldAddress)"
        typeLabel.text = "유형: \(item.type)"
        dateLabel.text = "일정: \(item.matchDateString ?? "") \(item.startTime ?? "") - \(item.endTime ?? "")"
        recruitLabel.text = "모집 용병: \(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount) 명"
        userNameLabel.text = "\(item.userName)"
    }
    
    private func configureUI() {
        contentView.addSubviews(titleLabel,
                                fieldLabel,
                                fieldAddress,
                                dateLabel,
                                typeLabel,
                                recruitLabel,
                                userNameLabel,
                                bookmarkButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10).priority(.low)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        fieldAddress.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldAddress.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitLabel.snp.bottom).offset(5)
            make.trailing.equalTo(snp.trailing).offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
