//
//  HelpViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/16/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var helpWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLabel.text = Messages.cannotLoadContent
        self.messageLabel.isHidden = true
        do
        {
            guard let privacyHTML = Bundle.main.path(forResource: "help", ofType: "html")
                else {
                    self.messageLabel.isHidden = false
                    return
            }
            
            let contents = try NSString(contentsOfFile: privacyHTML, encoding: String.Encoding.utf8.rawValue)
            let baseUrl = NSURL(fileURLWithPath: privacyHTML)
            
            helpWebView.loadHTMLString(contents as String, baseURL: baseUrl as URL)
        }
        catch
        {
            self.messageLabel.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
    }
}
