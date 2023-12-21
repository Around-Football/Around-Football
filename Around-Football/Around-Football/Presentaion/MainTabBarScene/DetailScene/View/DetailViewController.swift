//
//  DetailViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import Firebase
import RxCocoa
import RxSwift
import SnapKit
import Then

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: DetailViewModel
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    private let detailUserInfoView = DetailUserInfoView()
    private let detailView = DetailView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "DefaultRecruitImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private var typeLabel = UILabel().then {
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
    
    private let groundIconView = UIImageView().then {
        $0.image = UIImage(systemName: "mappin.and.ellipse")
    }
    
    private let contentDivider = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let bottomDivider = UIView().then {
        $0.backgroundColor = AFColor.grayScale200
    }
    
    private let sendMessageButton = AFSmallButton(buttonTitle: "채팅하기", color: AFColor.primary)
    private let sendRecruitButton = AFButton(buttonTitle: "신청하기", color: AFColor.secondary)
    private let bookMarkButton = UIButton().then {
        $0.setImage(UIImage(named: "AFBookmark"), for: .normal)
    }
    
    private lazy var bottomStackView = UIStackView().then {
        $0.addArrangedSubviews(bookMarkButton, sendRecruitButton)
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
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
        configeUI()
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
        navigationItem.title = ""
        navigationItem.titleView?.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: - Helper
    
    //유저에 따라 신청버튼 타이틀 설정
    private func setButtonUI() {
        if viewModel.isOwnRecruit() {
            let title = NSAttributedString(
                string: "신청 현황 보기",
                attributes: [.font: AFFont.titleSmall as Any]
            )
            sendRecruitButton.setAttributedTitle(title, for: .normal)
            //메세지 보내기 버튼 없애기
            sendMessageButton.isHidden = true
            bookMarkButton.isHidden = true
        } else {
            let title = NSAttributedString(
                string: "신청하기",
                attributes: [.font: AFFont.titleSmall as Any]
            )
            sendRecruitButton.setAttributedTitle(title, for: .normal)
            //메세지 보내기 버튼 원위치
            sendMessageButton.isHidden = false
            bookMarkButton.isHidden = false
        }
    }
    
    private func configureTypeLabel() {
        if let item = viewModel.getRecruit() {
            typeLabel.text = item.type
            typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        }
    }
    
    private func configureBookmarkStyle() {
        guard let user = viewModel.getCurrentUser(),
              let recruit = viewModel.getRecruit() else {
            setNormalBookmarkButton()
            return
        }
        
        viewModel.isSelectedBookmark = user.bookmarkedRecruit.contains(recruit.id)
        
        setupBookmarkButton()
    }
    
    private func setupBookmarkButton() {
        if viewModel.isSelectedBookmark == true {
            setSelectedBookmarkButton()
        } else {
            setNormalBookmarkButton()
        }
    }
    
    func setSelectedBookmarkButton() {
        UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.bookMarkButton.setImage(UIImage(named: "AFBookmarkSelect"), for: .normal)
        }
    }
    
    func setNormalBookmarkButton() {
        UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.bookMarkButton.setImage(UIImage(named: "AFBookmark"), for: .normal)
        }
    }
    
    private func configeUI() {
        configureTypeLabel() // type 라벨 스타일 세팅
        configureBookmarkStyle()
        view.backgroundColor = .white
        view.addSubviews(scrollView,
                         bottomDivider,
                         bottomStackView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(mainImageView,
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
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(186)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(51)
            make.height.equalTo(26)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
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
            make.width.equalTo(264)
        }
    }
    
    private func bind() {
//        let input = DetailViewModel.Input(invokedViewWillAppear: invokedViewWillAppear.asObserver())
//        let output = viewModel.transform(input)
        bindRecruitItem()
        bindButton()
        bindCurrentUser()
        bindRecruitUser()
    }
    
    private func bindRecruitItem() {
        viewModel.recruitItem
            .bind(onNext: { [weak self] recruit in
                guard let self = self else { return }
                // TODO: - Recruit 정보 변경된거 반영 (일정)
                dateLabel.text = recruit.matchDayString
                groundLabel.text = recruit.fieldName
                detailView.setValues(recruit: recruit)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButton() {
        
        sendRecruitButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self,
                      let recruit = viewModel.getRecruit() else { return }
                //TODO: -메세지 버튼 타이틀 분기처리 (작성자 or 신청자)
                ///글쓴이면 신청현황 보기, 아니면 신청한 UID에 추가
                if viewModel.getCurrentUser()?.id == recruit.userID {
                    viewModel.showApplicationStatusView(recruit: recruit)
                } else {
                    FirebaseAPI.shared.appendPendingApplicant(recruitID: recruit.id)
                }
            }
            .disposed(by: disposeBag)
        
        sendMessageButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                if (try? UserService.shared.currentUser_Rx.value()) != nil {
                    viewModel.checkChannelAndPushChatViewController()
                } else {
                    viewModel.showLoginView()
                }
            }
            .disposed(by: disposeBag)
        
        bookMarkButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                guard owner.viewModel.getCurrentUser() != nil else {
                    owner.viewModel.showLoginView()
                    return
                }
                
                if owner.viewModel.isSelectedBookmark == true {
                    owner.viewModel.removeBookmark() {
                        owner.setNormalBookmarkButton()
                        owner.viewModel.isSelectedBookmark = false
                    }
                    
                } else {
                    owner.viewModel.addBookmark() {
                        owner.setSelectedBookmarkButton()
                        owner.viewModel.isSelectedBookmark = true
                    }
                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentUser() {
        viewModel.currentUser
            .bind { [weak self] user in
                guard let self = self else { return }
                setButtonUI()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRecruitUser() {
        viewModel.recruitUser
            .bind { [weak self] user in
                print("bind", user.debugDescription)
                guard let self = self,
                      let user = user else { return }
                detailUserInfoView.setValues(user: user)
            }
            .disposed(by: disposeBag)
    }
}
