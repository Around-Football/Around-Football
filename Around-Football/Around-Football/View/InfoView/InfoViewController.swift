//
//  InfoViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileAndEditView = ProfileAndEditView()
    
    private let iconAndImage: [(icon: String, title: String)] = [
        (icon: "heart", title: "관심 글"),
        (icon: "doc.text", title: "작성 글"),
        (icon: "trophy", title: "트로피"),
        (icon: "clock", title: "풋살장 예약"),
        (icon: "ellipsis.message", title: "리뷰 작성"),
    ]
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(infoCell.self, forCellWithReuseIdentifier: infoCell.cellID)
        return cv
    }()
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "프로필"
        
        view.addSubviews(profileAndEditView)
        
        profileAndEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

}

extension InfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconAndImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectio
        return UICollectionViewCell()
    }
    
    
}
