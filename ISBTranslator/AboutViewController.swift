//
//  AboutViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/16/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ISBLabel: UILabel!
    @IBOutlet weak var aboutAppLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ISBLabel.text = StaticTexts.ISBCorporation
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.aboutAppLabel.text = StaticTexts.aboutApp + version
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.items?[1].title = StaticTexts.about
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        let viewCotroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacyPolicyScreen")
       
        self.navigationController?.pushViewController(viewCotroller, animated: true)
    }
}
