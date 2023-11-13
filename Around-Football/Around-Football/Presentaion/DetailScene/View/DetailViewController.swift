//
//  DetailViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//

import UIKit

import SnapKit
import Then

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let groundLabel = UILabel().then {
        $0.text = "중랑구립테니스장"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let groundAddressLabel = UILabel().then {
        $0.text = "서울 중랑구 구리포천고속도로 3"
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
    
    private(set) lazy var detailTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(DetailUserInfoCell.self, forCellReuseIdentifier: DetailUserInfoCell.cellID)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    private lazy var sendMessageButton = UIButton().then {
        $0.setTitle("메세지 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(clickedMessage), for: .touchUpInside)
    }

    private let detailUserInfoView = DetailUserInfoView()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configeUI()
    }
    
    // MARK: - Selector
    
    @objc
    private func clickedMessage() {
        //메세지 보내기 화면으로 넘어가기
    }
    
    @objc
    private func clickedApplyButton() {
        //TODO: -메세지 버튼 타이틀 분기처리 (작성자 or 신청자)
        
        //TODO: -신청하기 버튼 타이틀 분기처리
        let title = NSAttributedString(
            string: "신청 중",
            attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
        )
        applyButton.setAttributedTitle(title, for: .normal)
        
        //네비게이션 분기처리
        //TODO: -소미니 뷰 넣기 (여기는 코디네이터 어떻게 전달하지..뷰모델을 또 전달해야하나)
        let controller = ApplicationStatusViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    private func configeUI() {
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
                                detailTableView,
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
            //            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        groundAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(groundLabel.snp.bottom)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
//            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
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
        
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView2).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalTo(sendMessageButton.snp.top).offset(SuperviewOffsets.bottomPadding)
            make.height.equalTo(350)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.top.equalTo(detailTableView.snp.bottom).offset(SuperviewOffsets.topPadding)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(SuperviewOffsets.bottomPadding)
            make.height.equalTo(50)
        }
    }
}
