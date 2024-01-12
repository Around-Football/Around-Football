//
//  UITextField+.swift
//  Around-Football
//
//  Created by 강창현 on 1/8/24.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 50,
                                               height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addleftimage(image: UIImage, imageColor: UIColor) {
        let leftimage = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: image.size.width,
                                                  height: image.size.height))
        leftimage.image = image
        leftimage.tintColor = imageColor
        self.leftView = leftimage
        self.leftViewMode = .always
    }
    
    func setLeftView(image: UIImage, imageColor: UIColor) {
        let iconView = UIImageView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: image.size.width,
                                                 height: image.size.height))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: 30,
                                                             height: image.size.height))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = imageColor
    }
}
