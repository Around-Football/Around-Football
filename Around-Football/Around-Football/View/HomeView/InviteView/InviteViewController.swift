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
    
    private let previousButton = UIButton().then {
        $0.setTitle("<", for: .normal)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle(">", for: .normal)
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "2022년 01월"
    }
    
    private lazy var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    private lazy var dateCollectionView = UICollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(DateCell.self, forCellWithReuseIdentifier: DateCell.cellID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        let subViews = [previousButton, titleLabel, nextButton, dayStackView, dateCollectionView]
        subViews.forEach { subView in
            view.addSubview(subView)
        }
        
        titleLabel.
        
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
