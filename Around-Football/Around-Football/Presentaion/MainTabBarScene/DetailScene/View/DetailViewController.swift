//
//  DetailViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import Firebase
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: DetailViewModel
    private let invokedViewWillAppear = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    let detailUserInfoView = DetailUserInfoView()
    let detailView = DetailView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    lazy var navigationRightButton = UIBarButtonItem().then {
        var button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.transform = .init(rotationAngle: 90 * .pi / 180.0)
        let actions: [UIAction] = [UIAction(title: "수정", handler: { [weak self] _ in
            self?.viewModel.showEditDetailView()
        }), UIAction(title: "삭제", handler: { [weak self] _ in
            self?.showPopUp(title: "용병 게시글 삭제",
                            message: "삭제하시겠습니까?",
                            leftActionTitle: "취소",
                            rightActionTitle: "삭제",
                            rightActionCompletion: self?.viewModel.deleteRecruit)
        })]
        button.menu = UIMenu(children: actions)
        button.showsMenuAsPrimaryAction = true
        
        $0.customView = button
    }
    
    private let detailImageScrollView = DetailImageScrollView().then {
        $0.clipsToBounds = true
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "풋살"
        $0.textColor = AFColor.white
        $0.font = AFFont.text
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "12/15(금) 20:00"
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleMedium
    }
    
    private let groundLabel = UILabel().then {
        $0.text = "축구장 이름"
        $0.numberOfLines = 2
        $0.textColor = AFColor.secondary
        $0.font = AFFont.titleRegular
    }
    
    private let contentDivider = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let bottomDivider = UIView().then {
        $0.backgroundColor = AFColor.grayScale200
    }
    
    let sendMessageButton = AFSmallButton(buttonTitle: "채팅하기", color: AFColor.secondary)
    let sendRecruitButton = AFButton(buttonTitle: "신청하기", color: AFColor.primary)
    let bookMarkButton = UIButton().then {
        $0.setImage(UIImage(named: "AFBookmark"), for: .normal)
    }
    
    private lazy var bottomStackView = UIStackView().then {
        $0.addArrangedSubviews(bookMarkButton, sendRecruitButton)
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private lazy var navigationRightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(tappedNavigationRightBarButton)
        )
        barButton.tintColor = AFColor.grayScale200
        return barButton
    }()
    
    // MARK: - Lifecycles
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTypeLabel() // type 라벨 스타일 세팅
        configureBookmarkStyle()
        configeUI()
        configureRecruitInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invokedViewWillAppear.onNext(()) //cell 실시간 데이터 반영
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "용병 구해요"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AFColor.grayScale200
        ]
        navigationController?.navigationBar.tintColor = AFColor.grayScale200
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: - Helper
    
    //유저에 따라 신청버튼 타이틀 설정
    func setButtonUI(isEnabledSendButton: Bool,
                     sendButtonTitle: String,
                     isHiddenMessageButton: Bool,
                     isHiddenBookmark: Bool,
                     disabledBackground: UIColor,
                     disabledTitleColor: UIColor) {
        sendRecruitButton.isEnabled = isEnabledSendButton
        sendRecruitButton.setTitle(sendButtonTitle, for: .normal)
        sendMessageButton.isHidden = isHiddenMessageButton
        bookMarkButton.isHidden = isHiddenBookmark
        if !isEnabledSendButton {
            sendRecruitButton.setBackgroundColor(disabledBackground, for: .disabled)
            sendRecruitButton.setTitleColor(disabledTitleColor, for: .disabled)
        }
    }
    
    func configureTypeLabel() {
        if let item = viewModel.getRecruit() {
            typeLabel.text = item.type
            typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        }
    }
    
    private func configureRecruitInfo() {
        guard let recruit = viewModel.getRecruit() else { return }
        dateLabel.text = recruit.matchDayAndStartTime
        groundLabel.text = recruit.fieldName
        detailView.setValues(recruit: recruit
        )
        var downloadImages = [UIImage?]()
        
        recruit.recruitImages.forEach { url in
            let imageView: UIImageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: URL(string: url),
                                  placeholder: AFIcon.defaultFieldImage)
            downloadImages.append(imageView.image)
        }
        
        detailImageScrollView.configure(type: recruit.type, images: downloadImages)
    }
    
    func configureBookmarkStyle() {
        guard let user = viewModel.getCurrentUser(),
              let recruit = viewModel.getRecruit() else {
            setNormalBookmarkButton()
            return
        }
        
        viewModel.isSelectedBookmark = user.bookmarkedRecruit.contains(recruit.id)
        
        if viewModel.isSelectedBookmark == true {
            setSelectedBookmarkButton()
        } else {
            setNormalBookmarkButton()
        }
    }
    
    private func setSelectedBookmarkButton() {
        UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.bookMarkButton.setImage(UIImage(named: "AFBookmarkSelect"), for: .normal)
        }
    }
    
    private func setNormalBookmarkButton() {
        UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.bookMarkButton.setImage(UIImage(named: "AFBookmark"), for: .normal)
        }
    }
    
    @objc
    private func tappedNavigationRightBarButton() {
        alertActionSheet(
            message:
                    .actionSheet,
            actions:
                [
                    UIAlertAction(
                        title: "차단하기",
                        style: .destructive,
                        handler: { [weak self] _ in
                            self?.showPopUp(
                                title: "사용자 차단",
                                message: "정말로 차단하시겠습니까?"
                            )
                        }
                    ),
                    UIAlertAction(
                        title: "신고하기",
                        style: .default,
                        handler: { [weak self] _ in
                            self?.sendEmail(
                                message: .userBlock(
                                    userName: self?.viewModel.fetchRecruitUser() ?? "직접 입력"
                                )
                            )
                        }
                    ),
                    UIAlertAction(
                        title: "취소",
                        style: .cancel,
                        handler: nil
                    )
                ]
        )
    }
    
    private func configeUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = navigationRightBarButton
        view.addSubviews(scrollView,
                         bottomDivider,
                         bottomStackView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(detailImageScrollView,
                                typeLabel,
                                dateLabel,
                                groundLabel,
                                detailUserInfoView,
                                sendMessageButton,
                                contentDivider,
                                detailView
        )
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomDivider.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-55)
            make.width.equalToSuperview()
        }
        
        detailImageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            //            make.leading.equalToSuperview()
            //            make.trailing.equalToSuperview()
            //            make.height.equalTo(220)
            make.width.equalToSuperview()
            make.height.equalTo(detailImageScrollView.snp.width).multipliedBy(0.54)
            
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageScrollView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(51)
            make.height.equalTo(26)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageScrollView.snp.bottom).offset(20)
            make.leading.equalTo(typeLabel.snp.trailing).offset(12)
        }
        
        groundLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(groundLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(40)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.centerY.equalTo(detailUserInfoView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(96)
            make.height.equalTo(36)
        }
        
        contentDivider.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(contentDivider.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview()
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(0.4)
            make.bottom.equalTo(bottomStackView.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview()
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-36)
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        sendRecruitButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(264)
        }
    }
    
    private func bind() {
        let input = DetailViewModel.Input(invokedViewWillAppear: invokedViewWillAppear)
        let output = viewModel.transform(input)
        bindButtonAction()
        bindRecruitUser()
        bindButtonStyle(by: output.recruitStatus)
        bindRecruit()
    }
}
