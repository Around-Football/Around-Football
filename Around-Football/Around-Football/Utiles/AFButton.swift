//
//  CustomButton.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

import RxSwift

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

final class AFMenuButton: UIButton {
    
    var menuButtonSubject = PublishSubject<String?>()
    var config = UIButton.Configuration.plain()
    
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
        let image = UIImage(systemName: "chevron.down")
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        setImage(image?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal),
                 for: .normal)
        layer.cornerRadius = LayoutOptions.cornerRadious
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        showsMenuAsPrimaryAction = true
        semanticContentAttribute = .forceRightToLeft
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { city in
            UIAction(title: city) { [weak self] _ in
                guard let self else { return }
                menuButtonSubject.onNext(city)
                setTitle(city, for: .normal)
            }
        })
        
        config.imagePadding = 30
    }
}
