//
//  FilterViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/20/23.
//

//TODO: - 삭제
//import UIKit
//
//import RxSwift
//import RxCocoa
//import SnapKit
//import Then
//
//final class LocationFilterViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    private let cities: [String]  = ["서울", "경기", "인천", "세종", "강원", "충청", "경상", "전라", "제주"]
//    
//    var selectedCity: String?
//    var selectedIndexPath: IndexPath?
//    
//    private let titleLabel = UILabel().then {
//        $0.text = "찾고 싶은 지역을 선택해주세요"
//        $0.font = .systemFont(ofSize: 24, weight: .bold)
//    }
//    
//    private lazy var confirmButton = UIButton().then {
//        $0.setTitle("확인", for: .normal)
//        
//        // 버튼 스타일 설정
//        $0.setTitleColor(.blue, for: .normal)
//        $0.layer.cornerRadius = LayoutOptions.cornerRadious
//        $0.layer.borderWidth = 1.0
//        $0.layer.borderColor = UIColor.blue.cgColor
//        $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
//    }
//    
//    private lazy var dismissButton = UIButton().then {
//        $0.setTitle("취소", for: .normal)
//        
//        // 버튼 스타일 설정
//        $0.setTitleColor(.red, for: .normal)
//        $0.layer.cornerRadius = LayoutOptions.cornerRadious
//        $0.layer.borderWidth = 1.0
//        $0.layer.borderColor = UIColor.red.cgColor
//        $0.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private lazy var cityCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//        
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = .clear
//        cv.showsVerticalScrollIndicator = false
//        cv.delegate = self
//        cv.dataSource = self
//        cv.register(LocationFillterCell.self, forCellWithReuseIdentifier: LocationFillterCell.cellID)
//        return cv
//    }()
//    
//    private let buttonStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.distribution = .fillEqually
//        $0.alignment = .center
//        $0.spacing = 20
//    }
//    
//    // MARK: - Lifecycles
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//    }
//    
//    // MARK: - Seletors
//    
//    @objc
//    func didTapConfirmButton() {
//        if let indexPath = cityCollectionView.indexPathsForSelectedItems?.first,
//           let cell = cityCollectionView.cellForItem(at: indexPath) as? LocationFillterCell {
//            self.selectedCity = cell.selectedCity
//        }
//        dismiss(animated: true)
//    }
//    
//    @objc
//    func didTapDismissButton() {
//        dismiss(animated: true)
//    }
//    
//    // MARK: - Helpers
//
//    private func configureUI() {
//        view.backgroundColor = .white
//        
//        buttonStackView.addArrangedSubviews(dismissButton,
//                                            confirmButton)
//        view.addSubviews(titleLabel,
//                         cityCollectionView,
//                         buttonStackView)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
//            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
//            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
//        }
//        
//        cityCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(titleLabel)
//            make.height.equalTo(215)
//        }
//        
//        buttonStackView.snp.makeConstraints { make in
//            make.top.equalTo(cityCollectionView.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(titleLabel)
//        }
//    }
//}
//
//extension LocationFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        cities.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationFillterCell.cellID, for: indexPath) as! LocationFillterCell
//        cell.setValues(title: cities[indexPath.item])
//        
//        //select된 cell 초기화
//        if selectedIndexPath == nil {
//            cell.isSelected = false
//            cell.cityLabel.layer.borderColor = UIColor.gray.cgColor
//            cell.cityLabel.textColor = .gray
//        }
//
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: (view.frame.width / 2) - 30, height: 35)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if let previousSelectedIndexPath = selectedIndexPath,
//           let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? LocationFillterCell {
//            previousSelectedCell.isSelected = false
//            previousSelectedCell.cityLabel.layer.borderColor = UIColor.gray.cgColor
//            previousSelectedCell.cityLabel.textColor = .gray
//        }
//        
//        guard
//            let selectedCell = collectionView.cellForItem(at: indexPath) as? LocationFillterCell
//        else { return }
//        
//        selectedCell.isSelected = true
//        selectedCell.cityLabel.layer.borderColor = UIColor.black.cgColor
//        selectedCell.cityLabel.textColor = .label
//        
//        // 선택한 셀의 indexPath를 저장
//        self.selectedCity = cities[indexPath.item]
//        selectedIndexPath = indexPath
//    }
//}
