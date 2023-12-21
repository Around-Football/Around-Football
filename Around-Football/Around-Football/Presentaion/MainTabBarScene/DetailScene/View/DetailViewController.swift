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
    private var user = try? UserService.shared.currentUser_Rx.value()
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
    
    private let grayDividerView = UIView().then {
        $0.backgroundColor = AFColor.grayScale50
    }
    
    private let sendMessageButton = AFSmallButton(buttonTitle: "채팅하기", color: AFColor.primary)
    private let sendRecruitButton = AFButton(buttonTitle: "신청하기", color: AFColor.secondary)
    
    
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
        bindUI()
        configeUI()
        contentView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        sendRecruitButton.isEnabled = true
        sendRecruitButton.isUserInteractionEnabled = true
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
    
    // MARK: - Selector
    
    @objc
    private func sendMessageButtonTapped() {
        print("DEBUG - TAP")
        if (try? UserService.shared.currentUser_Rx.value()) != nil {
            viewModel.checkChannelAndPushChatViewController()
        } else {
            viewModel.showLoginView()
        }
    }
    
    @objc
    private func sendRecruitButtonTapped() {
        print("DEBUG - TAP")
        //TODO: -메세지 버튼 타이틀 분기처리 (작성자 or 신청자)
        ///글쓴이면 신청현황 보기, 아니면 신청한 UID에 추가
        if user?.id == viewModel.recruitItem?.userID {
            viewModel.coordinator?.pushApplicationStatusViewController(recruit: viewModel.recruitItem!)
        } else {
            FirebaseAPI.shared.appendPendingApplicant(fieldID: viewModel.recruitItem?.fieldID)
        }
    }
    
    // MARK: - Helper
    
    //유저에 따라 신청버튼 타이틀 설정
    private func setButtonTitle() {
        //글쓴이면 신청현황, 아니면 신청하기로
        if user?.id == viewModel.recruitItem?.userID {
            let title = NSAttributedString(
                string: "신청 현황 보기",
                attributes: [.font: AFFont.titleSmall as Any]
            )
            sendRecruitButton.setAttributedTitle(title, for: .normal)
            //메세지 보내기 버튼 없애기
            sendMessageButton.isHidden = true
        } else {
            let title = NSAttributedString(
                string: "신청하기",
                attributes: [.font: AFFont.titleSmall as Any]
            )
            sendRecruitButton.setAttributedTitle(title, for: .normal)
            //메세지 보내기 버튼 원위치
            sendMessageButton.isHidden = false
        }
    }
    
    private func setTypeLabelStyle() {
        if let item = viewModel.recruitItem {
            typeLabel.text = item.type
            typeLabel.backgroundColor = item.type == "축구" ? AFColor.soccor : AFColor.futsal
        }
    }
    
    
    private func bindUI() {
        let input = DetailViewModel.Input(invokedViewWillAppear: invokedViewWillAppear.asObserver())
        
        let output = viewModel.transform(input)
        
        output.recruitItem
            .do { recruit in
                let userRef = REF_USER.document(recruit.userID)
                
                userRef.getDocument(as: User.self) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let user):
                        print("readUser 성공: \(user)")
                        detailUserInfoView.setValues(user: user)
                    case .failure(let error):
                        print("readUser 에러: \(error)")
                    }
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        output
            .recruitItem
            .bind(onNext: { [weak self] recruit in
                guard let self else { return }
                // TODO: - Recruit 정보 변경된거 반영 (일정)
                dateLabel.text = recruit.matchDate.debugDescription
                groundLabel.text = recruit.fieldName
                //                groundLabel.text = recruit.fieldAddress
                detailView.setValues(item: recruit)
            }).disposed(by: disposeBag)
        
        sendRecruitButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                //TODO: -메세지 버튼 타이틀 분기처리 (작성자 or 신청자)
                ///글쓴이면 신청현황 보기, 아니면 신청한 UID에 추가
                if user?.id == viewModel.recruitItem?.userID {
                    viewModel.coordinator?.pushApplicationStatusViewController(recruit: viewModel.recruitItem!)
                } else {
                    FirebaseAPI.shared.appendPendingApplicant(fieldID: viewModel.recruitItem?.fieldID)
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
    }
    
    private func configeUI() {
        setButtonTitle() // 신청하기 버튼 세팅
        setTypeLabelStyle() // type 라벨 스타일 세팅
        view.backgroundColor = .white
        view.addSubviews(scrollView,
                         sendRecruitButton)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(mainImageView,
                                typeLabel,
                                dateLabel,
                                groundLabel,
                                detailUserInfoView,
                                sendMessageButton,
                                grayDividerView,
                                detailView
        )
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(0)
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
        
        grayDividerView.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(grayDividerView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview()
        }
        
        sendRecruitButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
