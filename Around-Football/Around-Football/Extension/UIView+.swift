//
//  Extension.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/2/23.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    func setShadowLayer() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = LayoutOptions.shadowCornerRadious
        self.layer.shadowOpacity = LayoutOptions.shadowOpacity

    }
}

// MARK: - StackView 생성 시 add
extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
