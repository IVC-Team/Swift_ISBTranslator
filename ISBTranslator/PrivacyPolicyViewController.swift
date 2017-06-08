//
//  PrivacyPolicyViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/19/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var privacyPolicyWebView: UIWebView!
    @IBOutlet weak var backBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLabel.text = Messages.cannotLoadContent
        self.messageLabel.isHidden = true
        
        //Load html file
        do
        {
            guard let privacyHTML = Bundle.main.path(forResource: "privacy", ofType: "html")
                else {
                    self.messageLabel.isHidden = false
                    return
                }
            
            let contents = try NSString(contentsOfFile: privacyHTML, encoding: String.Encoding.utf8.rawValue)
            let baseUrl = NSURL(fileURLWithPath: privacyHTML)
            
            privacyPolicyWebView.loadHTMLString(contents as String, baseURL: baseUrl as URL)
        }
        catch
        {
            self.messageLabel.isHidden = false
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.items?[1].title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.navigationBar.items?[1].title = StaticTexts.about
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil
        {
            self.navigationController?.navigationBar.items?[1].title = StaticTexts.about
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
