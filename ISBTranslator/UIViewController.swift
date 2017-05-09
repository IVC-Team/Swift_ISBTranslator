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
    
    func showMessage(message: String){
        let alert: UIAlertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addLoading() -> UIActivityIndicatorView
    {
        let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loading.center = self.view.center
        loading.hidesWhenStopped = true
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        self.view.addSubview(loading)
        
        return loading
    }
}
