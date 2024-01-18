//
//  ImageView.swift
//  Around-Football
//
//  Created by 강창현 on 1/3/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class InviteImageView: UIImageView {
    lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: AFIcon.deleteButton), for: .normal)
        $0.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
    @objc
    private func removeImage() {
        self.removeFromSuperview()
        NotificationCenter.default.post(name: .updateUploadImages, object: nil)
    }
}
