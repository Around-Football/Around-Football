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
                                               width: 10,
                                               height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addleftimage(image:UIImage) {
        let leftimage = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: image.size.width,
                                                  height: image.size.height))
        leftimage.image = image
        self.leftView = leftimage
        self.leftViewMode = .always
    }
}
