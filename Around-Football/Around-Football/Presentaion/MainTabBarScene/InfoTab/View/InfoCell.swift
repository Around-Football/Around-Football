//
//  infoCell.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/9/23.
//

import UIKit


import RxSwift
import RxCocoa

final class InfoCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellID = "infoCell"
    private let disposeBag = DisposeBag()
    
    private var titleLable = UILabel().then {
        $0.text = "타이틀"
        $0.font = AFFont.text
    }
    
    private let rightIcon = UIImageView(image: UIImage(named: AFIcon.rightButton))
    
    private let notificationSwitch = UISwitch().then {
        $0.isOn = UIApplication.shared.isRegisteredForRemoteNotifications
        $0.isHidden = true
    }
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setValues(title: String, usingRightIcon: Bool = true, usingSwitch: Bool = false) {
        titleLable.text = title
        rightIcon.isHidden = !usingRightIcon
        notificationSwitch.isHidden = !usingSwitch
        bind()
    }
    
    private func bind() {
        if !notificationSwitch.isHidden {
            bindSwitch()
        }
    }
    
    private func bindSwitch() {
        notificationSwitch.rx.isOn
            .bind { isOn in
                if isOn {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    UIApplication.shared.unregisterForRemoteNotifications()
                }
            }
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        contentView.addSubviews(titleLable, rightIcon, notificationSwitch)
        
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
            make.bottom.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()

        }
    }
}
