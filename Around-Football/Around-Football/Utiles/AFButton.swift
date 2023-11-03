//
//  CustomButton.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

final class AFButton: UIButton {
    
    // MARK: - Properties
    
    private var buttonTitle: String
    var buttonActionHandler: (() -> Void)?
    
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
    
    @objc 
    func buttonClicked() {
        print("DEBUG: buttonClicked")
        if let buttonActionHandler {
            buttonActionHandler()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = LayoutOptions.cornerRadious
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
}
