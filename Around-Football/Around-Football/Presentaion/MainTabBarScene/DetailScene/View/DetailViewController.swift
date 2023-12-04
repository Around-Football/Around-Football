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
    
    private var viewModel: DetailViewModel
    private var invokedViewWillAppear = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    private let detailUserInfoView = DetailUserInfoView()
    private let detailView = DetailView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let groundLabel = UILabel().then {
        $0.text = "축구장 이름"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let groundAddressLabel = UILabel().then {
        $0.text = "축구장 주소"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 10)
    }
    
    private lazy var applyButton = UIButton().then {
        let title = NSAttributedString(
            string: "신청하기",
            attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
        )
        $0.setAttributedTitle(title, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(clickedApplyButton), for: .touchUpInside)
    }
    
    private let groundIconView = UIImageView().then {
        $0.image = UIImage(systemName: "mappin.and.ellipse")
    }
    
    private let grayLineView1 = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    private let grayLineView2 = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    private lazy var sendMessageButton = UIButton().then {
        $0.setTitle("메세지 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(clickedMessage), for: .touchUpInside)
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
        configeUI()
        bindUI()
        invokedViewWillAppear.onNext(())
    }
    
    // MARK: - Selector
    
    @objc
    private func clickedMessage() {
        viewModel.checkChannel()
    }
    
    @objc
    private func clickedApplyButton() {
        //TODO: -메세지 버튼 타이틀 분기처리 (작성자 or 신청자)
        ///글쓴이면 신청현황 보기, 아니면 신청한 UID에 추가
        if Auth.auth().currentUser?.uid == viewModel.recruitItem?.userID {
            viewModel.coordinator?.pushApplicationStatusViewController()
        } else {
            viewModel.recruitItem?.apply(withUserID: Auth.auth().currentUser?.uid)
        }
    }
    
    // MARK: - Helper
    
    private func setButtonTitle() {
        //글쓴이면 신청현황, 아니면 신청하기로
        if Auth.auth().currentUser?.uid == viewModel.recruitItem?.userID {
            let title = NSAttributedString(
                string: "신청 현황",
                attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
            )
            applyButton.setAttributedTitle(title, for: .normal)
        } else {
            let title = NSAttributedString(
                string: "신청 하기",
                attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
            )
            applyButton.setAttributedTitle(title, for: .normal)
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
                    print("readUser성공: \(user)")
                    detailUserInfoView.setValues(user: user)
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
            }
        }
        .subscribe()
        .disposed(by: disposeBag)
        
        output
            .recruitItem
            .do(onNext: { [weak self] item in
                guard let self else { return }
                groundLabel.text = item.fieldName
                groundAddressLabel.text = item.fieldAddress
                detailView.setValues(item: item)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func configeUI() {
        setButtonTitle() //신청하기 버튼 세팅
        navigationItem.title = viewModel.recruitItem?.title
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(mainImageView,
                                groundLabel,
                                groundAddressLabel,
                                applyButton,
                                grayLineView1,
                                detailUserInfoView,
                                grayLineView2,
                                detailView,
                                sendMessageButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        groundLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
        }
        
        groundAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(groundLabel.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.bottom.equalTo(grayLineView1.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.bottom.equalTo(grayLineView1.snp.top).offset(SuperviewOffsets.bottomPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.width.equalTo(70)
            make.height.equalTo(45)
        }
        
        grayLineView1.snp.makeConstraints { make in
            make.top.equalTo(groundAddressLabel.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        grayLineView2.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView2).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(sendMessageButton.snp.top).offset(SuperviewOffsets.bottomPadding)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding).priority(.required)
            make.height.equalTo(50)
        }
    }
}
