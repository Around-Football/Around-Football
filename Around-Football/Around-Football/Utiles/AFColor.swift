//
//  AFColor.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/16/23.
//

import UIKit

extension UIColor {
    //hexCode 파라미터 추가
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

enum AFColor {
    static let primary = UIColor(hexCode: "#D1FE00")
    static let secondary = UIColor(hexCode: "#0C090E")
    
    static let grayScale400 = UIColor(hexCode: "#292929")
    static let grayScale300 = UIColor(hexCode: "#848484")
    static let grayScale200 = UIColor(hexCode: "#A8A8A8")
    static let grayScale100 = UIColor(hexCode: "#E4E4E4")
    static let grayScale50 = UIColor(hexCode: "#F1F1F1")
    static let white = UIColor(hexCode: "#FFFFFF")
    
    static let sunday = UIColor(hexCode: "#E11100")
    static let futsal = UIColor(hexCode: "#00BE08")
    static let soccor = UIColor(hexCode: "#006DED")
    
    static let grayMessage = UIColor(hexCode: "#F8F8F8")
    static let primaryMessage = primary.withAlphaComponent(0.5)
}

