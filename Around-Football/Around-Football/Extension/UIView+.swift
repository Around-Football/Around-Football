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
    // MARK: - StackView 생성 시 add
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubviews(subview)
        }
    }
    
}
