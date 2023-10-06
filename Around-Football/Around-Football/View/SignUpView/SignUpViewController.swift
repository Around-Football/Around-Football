//
//  SignUpViewController.swift
//  Around-Football
//
//  Created by 강창현 on 10/6/23.
//

import Foundation
import UIKit
import SnapKit
import Then

class SignUpViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black
        // FIXME: - LargeTitle + Bold 구현
        $0.font = .boldSystemFont(ofSize: 30)
        
//        $0.font = .preferredFont(forTextStyle: .largeTitle)
        
        //  label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20) // leading margin을 20 포인트로 설정
        }
    }
}
