//
//  CustomButton.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

final class CustomButton: UIButton {
    private var buttonTitle: String
    
    init(frame: CGRect, buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 5
        clipsToBounds = true
        addTarget(self, action: #selector(clickedButton), for: .touchUpInside)
    }
    
    @objc func clickedButton() {
        
    }
    
}
