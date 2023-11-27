//
//  DetailUserInfoCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/1/23.
//
//
//import UIKit
//
//import SnapKit
//import Then

// TODO: - Rx 이전 함수. 삭제하기
//
//final class DetailUserInfoCell: UITableViewCell {
//    
//    // MARK: - Properties
//    
//    static let cellID = "DetailUserInfoCell"
//    
//    private var title = UILabel().then {
//        $0.font = .systemFont(ofSize: 15)
//        $0.textColor = .gray
//    }
//    
//    private var contents = UILabel().then {
//        $0.font = .systemFont(ofSize: 15)
//        $0.textColor = .black
//        $0.numberOfLines = 0
//    }
//    
//    // MARK: - Lifecycles
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Helpers
//    
//    func setValues(contents: String?) {
//        self.contents.text = contents
//    }
//    
//    private func configureUI() {
//        selectionStyle = .none
//        addSubviews(title, contents)
//        
//        title.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.equalTo(50)
//        }
//        
//        contents.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(title.snp.trailing).offset(SuperviewOffsets.leadingPadding)
//            make.trailing.equalToSuperview()
//        }
//    }
//}
