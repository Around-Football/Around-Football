//
//  CustomButton.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import RxSwift
import SnapKit
import Then

// MARK: - 큰 버튼

final class AFButton: UIButton {
    
    // MARK: - Properties
    
    var buttonActionHandler: (() -> Void)?
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, color: UIColor) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc
    func buttonClicked() {
        print("DEBUG: buttonClicked")
        if let buttonActionHandler {
            buttonActionHandler()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, color: UIColor) {
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = LayoutOptions.cornerRadious
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        color == .black ? setTitleColor(.white, for: .normal) : setTitleColor(.black, for: .normal)
        setBackgroundColor(color, for: .normal)
        setTitleColor(AFColor.grayScale300, for: .disabled)
        setBackgroundColor(AFColor.grayScale100, for: .disabled)
    }
}

// MARK: - 작은 버튼

final class AFSmallButton: UIButton {
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String) {
        setTitle(buttonTitle, for: .normal)
        titleLabel?.font = AFFont.text
        setTitleColor(AFColor.grayScale200, for: .normal)
        setTitleColor(.black, for: .selected)
        layer.cornerRadius = LayoutOptions.cornerRadious
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        setBackgroundColor(AFColor.primary, for: .selected)
        setBackgroundColor(.clear, for: .normal)
    }
}

// MARK: - MENU버튼

final class AFMenuButton: UIButton {
    
    var menuButtonSubject = PublishSubject<String?>()
    let chevronImage = UIImage(systemName: "chevron.down")
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, menus: [String]) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, menus: menus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, menus: [String]) {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        tintColor = .black
        layer.cornerRadius = LayoutOptions.cornerRadious
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        showsMenuAsPrimaryAction = true
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                menuButtonSubject.onNext(city)
                setTitle(city, for: .normal)
            }
        })
        
        if let titleLabel = titleLabel {
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
        }
        
        // Add the chevronImage directly to the button
        if let chevronImage = chevronImage {
            let chevronImageView = UIImageView(image: chevronImage)
            addSubview(chevronImageView)
            chevronImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        }
    }
}
