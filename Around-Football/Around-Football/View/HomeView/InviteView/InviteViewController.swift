//
//  InviteViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import SnapKit
import Then

final class InviteViewController: UIViewController {
    
    private let calender = Calendar.current
    
//    calender.dateComponents([.month, .day, .year], from: Date())
//    calender.date(byAdding: DateComponents(month: 1, day: 1), to: Date())
    
    private let placeView = GroundTitleView()
    
    private let peopleView = PeopleCountView()
    
    private let previousButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
    }
    
    private let nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    
    private var titleLabel = UILabel().then {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월"
        let dateCreatedAt = Date(timeIntervalSinceNow: Date().timeIntervalSinceNow)
        $0.text = dateFormatter.string(from: dateCreatedAt)
    }
    
    private lazy var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<days.count {
            let label = UILabel()
            label.text = days[i]
            label.textAlignment = .center
            
            switch i {
            case _ where i == 0:
                label.textColor = .red
            case _ where i == 6:
                label.textColor = .blue
            default:
                label.textColor = .gray
            }
            
            $0.addArrangedSubview(label)
        }
    }
    
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(DateCell.self, forCellWithReuseIdentifier: DateCell.cellID)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "용병 구하기"
        
        view.addSubviews(placeView,
                         peopleView,
                         titleLabel,
                         nextButton,
                         previousButton,
                         dayStackView,
                         dateCollectionView)
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 2/3)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(UIScreen.main.bounds.width * 1/3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        previousButton.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.bottom).offset(40)
            make.trailing.equalTo(nextButton.snp.leading).offset(-20)
        }
        
        dayStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

extension InviteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.cellID, for: indexPath) as! DateCell
        cell.dateLabel.text = "1"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 7
        return CGSize(width: width, height: width * 1.3)
    }
}
