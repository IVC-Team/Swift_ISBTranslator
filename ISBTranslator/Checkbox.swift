//
//  Checkbox.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/11/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

protocol CheckboxDelegate {
    func checkboxClickCallBack(selected: Bool, index: Int?)
}

class Checkbox: UIButton {

    // Images
    let checkedImage = UIImage(named: "checkbox_checked")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox_unchecked")! as UIImage
    var checkedBorderShow: Bool = false
    var borderColor: UIColor = UIColor.gray
    var index: Int?
    
     var delegate: CheckboxDelegate!
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
                self.layer.backgroundColor = UIColor.mainColor.cgColor
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.mainColor.cgColor                
            } else {
                self.setImage(nil, for: .normal)
                self.layer.backgroundColor = UIColor.transparent.cgColor
                self.layer.borderWidth = 1
                self.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.layer.cornerRadius = self.frame.width/2
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            
            if checkedBorderShow && isChecked {
                self.layer.borderWidth = 1
                self.layer.borderColor = borderColor.cgColor
            }
            
            if !isChecked {
                self.layer.borderColor = borderColor.cgColor
            }
            
            if delegate != nil {
                delegate.checkboxClickCallBack(selected: isChecked, index: self.index)
            }
            
        }
    }
    
    func setBorder(color: UIColor)
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        borderColor = color

    }
}
