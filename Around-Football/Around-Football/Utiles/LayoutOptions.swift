//
//  LayoutOptions.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/7/23.
//

import UIKit

enum LayoutOptions {
    static let cornerRadious: CGFloat = 8
    static let shadowCornerRadious: CGFloat = 5
    static let shadowOpacity: Float = 0.3
    static let titleSize: CGFloat = 15
}

enum SuperviewOffsets {
    static let topPadding: Float = 24
    static let leadingPadding: Float = 20
    static let trailingPadding: Float = -20
    static let bottomPadding: Float = -24
}

extension UIColor {
    
    /// Convert color to image
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
