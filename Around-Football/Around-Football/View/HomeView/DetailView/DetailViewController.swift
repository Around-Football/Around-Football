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
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
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
    
    private let groundIconView = UIImageView().then {
        $0.image = UIImage(systemName: "mappin.and.ellipse")
    }
    
    private let grayLineView1 = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    private let grayLineView2 = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    private lazy var detailTableView = UITableView().then {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configeUI()
    }
    
    @objc private func clickedMessage() {
        //메세지 보내기 화면으로 넘어가기
    }

    private func configeUI() {
        view.backgroundColor = .white
        view.addSubviews(mainImageView,
                         groundLabel,
                         groundAddressLabel,
                         grayLineView1,
                         detailUserInfoView,
                         grayLineView2,
                         detailTableView,
                         sendMessageButton)
        
        mainImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        groundLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        groundAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(groundLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        grayLineView1.snp.makeConstraints { make in
            make.top.equalTo(groundAddressLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        grayLineView2.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView2).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.top.equalTo(detailTableView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    //셀 갯수 (임시)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    //셀 높이 (임시)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 6 ? 100 : 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = ["일시", "게임", "모집", "구력", "NTRP", "게임비", "코멘트"]
        let contents = ["2023.09.30(토) 17:00~19:00", "풋살", "남2(20,30,40대)", "2년 이하", "3.0", "인당 10,000원", "1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다!"]
        
        let cell = detailTableView.dequeueReusableCell(withIdentifier: DetailUserInfoCell.cellID, for: indexPath) as! DetailUserInfoCell
        cell.title.text = titles[indexPath.row]
        cell.contents.text = contents[indexPath.row]
        return cell
    }
    
}

//#Preview {
//    DetailViewController()
//}
