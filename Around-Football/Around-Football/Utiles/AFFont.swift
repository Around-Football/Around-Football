//
//  UIFont+.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/16/23.
//

import UIKit

enum AFFont {
    static let text = UIFont(name: "Pretendard-Regular", size: 16)
    static let button = UIFont(name: "Pretendard-SemiBold", size: 16)
    
    static let titleLarge = UIFont(name: "Pretendard-Bold", size: 28)
    static let titleMedium = UIFont(name: "Pretendard-SemiBold", size: 24)
    static let titleRegular = UIFont(name: "Pretendard-SemiBold", size: 18)
    static let titleSmall = UIFont(name: "Pretendard-SemiBold", size: 14)
    static let titleCard = UIFont(name: "Pretendard-SemiBold", size: 16)
    
    static let filterMedium = UIFont(name: "Pretendard-Medium", size: 12)
    static let filterRegular = UIFont(name: "Pretendard-Regular", size: 12)
    static let filterDay = UIFont(name: "Pretendard-Light", size: 11)
}

final class AFTitleSmall: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        configureUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(title: String) {
        text = title
        font = AFFont.titleSmall
        textColor = AFColor.grayScale300
    }
}
