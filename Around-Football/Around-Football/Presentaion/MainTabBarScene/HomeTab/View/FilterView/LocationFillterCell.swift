//
//  LocationFillterCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 11/27/23.
//

//TODO: - 삭제
//import UIKit
//
//import SnapKit
//import Then
//
//final class LocationFillterCell: UICollectionViewCell {
//    
//    static let cellID = "LocationFillterCell"
//    var selectedCity: String?
//    
//    lazy var cityLabel = UILabel().then {
//        $0.text = "도시"
//        $0.textColor = .gray
//        $0.textAlignment = .center
//        $0.layer.cornerRadius = LayoutOptions.cornerRadious
//        $0.layer.borderWidth = 1.0
//        $0.layer.borderColor = UIColor.systemGray.cgColor
//    }
//    
//    // MARK: - Lifecycles
//    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        configureUI()
//    }
//    
//    // MARK: - Selectors
//    
//    func setValues(title: String) {
////        cityButton.setTitle(title, for: .normal)
//        cityLabel.text = title
//        selectedCity = title
//    }
//    
//    // MARK: - Helpers
//    
//    private func configureUI() {
//        addSubviews(cityLabel)
//        
//        cityLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
