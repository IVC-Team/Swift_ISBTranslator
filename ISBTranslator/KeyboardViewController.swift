//
//  KeyboardViewController.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/14/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UIPopoverPresentationControllerDelegate, SelectLanguageDelegate{
    
    @IBOutlet weak var textResultScrollView: UIScrollView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var inputTextTranslateTextField: UITextField!
    @IBOutlet weak var viewTextResultLabel: UILabel!
    @IBOutlet weak var languageScrollView: UIScrollView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var targetLanguageButton: UIButton!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    
    var sourceLanguage: String = Languages.english.rawValue
    var targetLanguage: String = Languages.japanese.rawValue
    var languageList: [String: String] = [:]
    var targetLanguageIsActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageList = LanguageList
        inputTextTranslateTextField.becomeFirstResponder() //open the keyboard
        self.hideKeyboardWhenTappedAround()//set hide keyboard acction - tap the space of screen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectLanguage" {
            let popoverViewController = segue.destination as! SelectLanguageViewController
            popoverViewController.delegate = self
            popoverViewController.preferredContentSize = CGSize(width: LanguagePopover.width.rawValue as CGFloat, height:LanguagePopover.height.rawValue as CGFloat)
            popoverViewController.popoverPresentationController?.delegate = self
            popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            popoverViewController.popoverPresentationController?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        }
    }
    
    func changeLanguage(selectedItem: Int)
    {
        if(targetLanguageIsActive){
            self.targetLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.targetLanguage = Array(self.languageList.values)[selectedItem]
        }else{
            self.sourceLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.sourceLanguage = Array(self.languageList.values)[selectedItem]
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func showKeyBoardButtonTapped(_ sender: Any) {
        inputTextTranslateTextField.becomeFirstResponder()
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
               
        let translation = Translation()
        translation.sourceLanguage = self.sourceLanguage
        translation.targetLanguage = self.targetLanguage
        translation.textSource = inputTextTranslateTextField.text
        
        translation.textTranslation(completion: { (translatedText) in
            self.viewTextResultLabel.text = translatedText
        })
    }
    
    @IBAction func sourceLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = false
    }
    
    @IBAction func targetLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = true
    }
    
    @IBAction func switchLanguageButtonTapped(_ sender: Any) {
        let sourceTemp = sourceLanguageButton.title(for: UIControlState.normal)
        let tergetTemp = targetLanguageButton.title(for: UIControlState.normal)
        
        self.targetLanguageButton.setTitle(sourceTemp, for: .normal)
        self.targetLanguage = self.languageList[sourceTemp!]!
        
        self.sourceLanguageButton.setTitle(tergetTemp, for: .normal)
        self.sourceLanguage = self.languageList[tergetTemp!]!
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardDidShow(notification: NSNotification) {
        changeLanguageView(notification: notification, keyboardIsShow: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        changeLanguageView(notification: notification, keyboardIsShow: false)
    }
    
    func changeLanguageView(notification: NSNotification, keyboardIsShow: Bool)
    {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        var heightChange: CGFloat = (languageScrollView.frame.origin.y + keyboardSize.height - tabBar.frame.height) as CGFloat
        
        if keyboardIsShow{
            heightChange = (languageScrollView.frame.origin.y - keyboardSize.height + tabBar.frame.height) as CGFloat
        }
        
        languageScrollView.frame = CGRect(x: languageScrollView.frame.origin.x, y: heightChange, width: languageScrollView.frame.width, height: languageScrollView.frame.height)
    }
    
}




