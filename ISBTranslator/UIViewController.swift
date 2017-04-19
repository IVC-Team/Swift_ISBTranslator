//
//  UIViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 4/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//
import UIKit

//Currently not use
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
