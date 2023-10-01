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
        $0.text = "2022년 01월"
    }
    
    private lazy var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
//    private lazy var dateCollectionView = UICollectionView().then {
//        $0.delegate = self
//        $0.dataSource = self
//        $0.register(DateCell.self, forCellWithReuseIdentifier: DateCell.cellID)
//    }

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
                         dayStackView)
        
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
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
}

extension InviteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.cellID, for: indexPath) as! DateCell
        return cell
    }
    
    
}
