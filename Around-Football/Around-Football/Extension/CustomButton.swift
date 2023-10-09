//
//  CustomButton.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

final class CustomButton: UIButton {
    // MARK: - Properties
    
    private var buttonTitle: String
    
    // MARK: - Lifecycles
    
    init(frame: CGRect, buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func buttonClicked() {
        print("DEBUG: buttonClicked")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 5
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
}
