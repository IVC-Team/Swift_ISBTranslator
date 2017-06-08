//
//  UIViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 4/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//
import UIKit

//Currently not use
extension UIViewController: SettingMenuDelegate {
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
    
    func showConfirmMessage(title: String, message: String, actionOK: @escaping ()->()){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                actionOK()
            }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
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
    
    func showSettingMenu(sourView: UIView){
        let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuSetting") as! SettingMenuViewController
        
        let newRect = CGRect(x: sourView.frame.width - 140, y: 0, width: 150, height: 200)
        
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.delegate = self as SettingMenuDelegate
        
        popoverViewController.preferredContentSize = CGSize(width: LanguagePopover.width.rawValue as! CGFloat, height:175)
        popoverViewController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        popoverViewController.popoverPresentationController?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
        popoverViewController.popoverPresentationController?.sourceView = sourView
        popoverViewController.popoverPresentationController?.sourceRect = newRect
        
        self.present(popoverViewController, animated: true, completion: nil)
    }
    
    func changeItem(selectedItem: Int) {
        var viewCotroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Settings.views[selectedItem])
        
        if selectedItem == 0 {
            viewCotroller = viewCotroller as! SettingViewController
        } else if selectedItem == 1 {
            viewCotroller = viewCotroller as! HistoryViewController
        }
        self.navigationController?.pushViewController(viewCotroller, animated: true)        
        //self.present(historyView, animated: true, completion: nil)
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 40, y: self.view.frame.size.height/2 - 20, width: self.view.frame.size.width - 80, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
