//
//  LayoutOptions.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/7/23.
//

import UIKit

enum LayoutOptions {
    static let cornerRadious: CGFloat = 5
    static let shadowCornerRadious: CGFloat = 5
    static let shadowOpacity: Float = 0.3
    static let titleSize: CGFloat = 15
}

enum SuperviewOffsets {
    static let topPadding: Float = 20
    static let leadingPadding: Float = 20
    static let trailingPadding: Float = -20
    static let bottomPadding: Float = -20
}

extension UIColor {
    static let backGroundGray = UIColor(named: "UIBackgroundGray")
    /// 푸른 파란색 (91, 156, 203, 1)
    static var primary = UIColor(red: 91/255, green: 156/255, blue: 203/255, alpha: 1)
    /// 연한 회색
    static var incomingMessageBackground = UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)

}
