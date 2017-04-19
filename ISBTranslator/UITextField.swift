//
//  UITextField+CustomUI.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/17/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

//Currently not use
extension UITextField {
    func setBottomBorder(color: CGColor) {
        self.borderStyle = .none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - 8.0 ,   width:  self.frame.size.width, height: 1.0)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
}
