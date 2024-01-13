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
    var infoPostViewModel: InfoPostViewModel?
    private var user: User?
    private var disposeBag = DisposeBag()
    private var recruitID: String?
    private var isSelectedButton: Bool?
    var isBookmarkCell: Bool?
    
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
        $0.setImage(UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        $0.tintColor = .label
        $0.isHidden = true //다른 cell은 안보이고, isBookmarkCell이 true일때만 보이도록 설정
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
                    infoPostViewModel?.removeBookmark(uid: user.id, recruitID: recruitID)
                    return false
                } else {
                    //북마크 추가 메서드
                    setSelectedBookmarkButton()
                    //북마크 추가
                    infoPostViewModel?.addBookmark(uid: user.id, recruitID: recruitID)
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
    
    //모집Date 비교
    func isDateInFuture(targetDate: Date) -> Bool {
        let currentDate = Date()
        let comparisonResult = currentDate.compare(targetDate)
        return comparisonResult == .orderedDescending
    }
    
    func bindContents(item: Recruit, isBookmark: Bool? = false) {
        let date = item.matchDate.dateValue()
        let formattedCellDate = formatMatchDate(date)
        
        if let isBookmark,
           isBookmark == true {
            bookmarkButton.isHidden = false
        }
        
        //cell에 사용할 id 세팅
        self.recruitID = item.id
        //북마크 버튼 바인딩
        setBookmarkBinding(recruitID: item.id)
        //UI정보 바인딩
        
        if item.acceptedApplicantsUID.count == item.recruitedPeopleCount {
            typeLabel.text = "마감"
            typeLabel.backgroundColor = AFColor.grayScale200
        } else {
            typeLabel.text = item.type
            typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        }

        //시간이 과거면 마감으로 표시
        if isDateInFuture(targetDate: item.matchDate.dateValue()) {
            typeLabel.text = "마감"
            typeLabel.backgroundColor = AFColor.grayScale200
        }
        
        dateLabel.text = formattedCellDate
        fieldLabel.text = "\(item.fieldName)"
        recruitLabel.text = " \(item.acceptedApplicantsUID.count) / \(item.recruitedPeopleCount)명 모집"
        
        //TODO: - 성별 input 추가되면 바인딩하기
//        genderLabel.text = item.gender
        
        // MARK: - 예전 디자인 코드
        //        titleLabel.text = item.title
        //        fieldAddress.text = "주소: \(item.fieldAddress)"
        //        userNameLabel.text = "\(item.userName)"
    }
    
    //북마크 버튼 세팅
    private func setBookmarkBinding(recruitID: String) {
        UserService.shared.currentUser_Rx
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] user in
                guard let self else { return }
                self.user = user
                isSelectedButton = user?.bookmarkedRecruit.filter { $0 == recruitID }.count != 0
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
                                genderLabel,
                                bookmarkButton)
        
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
        
        contentView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(28)
        }
    }
}
