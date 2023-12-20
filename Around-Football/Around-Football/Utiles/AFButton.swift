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
    // TODO: - 폰트?
    private func configureUI(buttonTitle: String, color: UIColor) {
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = LayoutOptions.cornerRadious
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        setBackgroundColor(color, for: .normal)
        setTitleColor(color == AFColor.primary ? .black : .white, for: .normal)
        setTitleColor(AFColor.grayScale300, for: .disabled)
        setBackgroundColor(AFColor.grayScale100, for: .disabled)
    }
}

// MARK: - 중간 버튼

final class AFMediumButton: UIButton {
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, color: UIColor) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, color: UIColor) {
        setTitle(buttonTitle, for: .normal)
        titleLabel?.font = AFFont.button
        setTitleColor(AFColor.grayScale200, for: .normal)
        setTitleColor(.black, for: .selected)
        layer.cornerRadius = LayoutOptions.cornerRadious
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        setBackgroundColor(color, for: .selected)
        setBackgroundColor(.clear, for: .normal)
    }
}

// MARK: - 작은 버튼

final class AFSmallButton: UIButton {
    
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
        titleLabel?.font = AFFont.titleSmall
        setTitleColor(color == AFColor.primary ? .black : .white, for: .normal)
        setTitleColor(AFColor.grayScale300, for: .disabled)
        setBackgroundColor(color, for: .normal)
        setBackgroundColor(AFColor.grayScale100, for: .disabled)
        layer.cornerRadius = 4
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
}


// MARK: - MENU 버튼

final class AFMenuButton: UIButton {
    
    var menuButtonSubject = PublishSubject<String?>()
    let chevronImage = UIImage(systemName: "chevron.down")
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, menus: [String]) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, menus: menus)
        
        menuButtonSubject.subscribe { [weak self] title in
            guard let self,
                  let title else { return }
            setTitle(title, for: .normal)
        }.disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    // TODO: - 폰트?
    private func configureUI(buttonTitle: String, menus: [String]) {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        tintColor = .black
        layer.cornerRadius = LayoutOptions.cornerRadious
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        showsMenuAsPrimaryAction = true
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                menuButtonSubject.onNext(title)
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


//필터뷰 동그란 버튼
final class AFRoundSmallButton: UIButton {
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, color: UIColor) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, color: UIColor) {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(AFColor.grayScale300, for: .normal)
        setBackgroundColor(.clear, for: .normal)
        setTitleColor(.white, for: .selected)
        setBackgroundColor(.black, for: .selected)
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        
        titleLabel?.font = AFFont.filterMedium
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
}

//필터뷰 동그란 메뉴 버튼
final class AFRoundMenuButton: UIButton {
    
    var menuButtonSubject = PublishSubject<String?>()
    let chevronImage = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, menus: [String]) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, menus: menus)
        //버튼 title 설정
        menuButtonSubject.subscribe { [weak self] title in
            guard let self,
                  let title else { return }
            setTitle(title, for: .normal)
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, menus: [String]) {
        titleLabel?.font = AFFont.filterMedium
        setTitle(buttonTitle, for: .normal)
        setTitleColor(AFColor.grayScale300, for: .normal)
        setImage(chevronImage, for: .normal)
        setBackgroundColor(.clear, for: .normal)
        setTitleColor(.white, for: .selected)
        setBackgroundColor(.black, for: .selected)
        tintColor = AFColor.grayScale300
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = AFColor.grayScale100.cgColor
        showsMenuAsPrimaryAction = true
        semanticContentAttribute = .forceRightToLeft
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                menuButtonSubject.onNext(title)
            }
        })
    }
}

