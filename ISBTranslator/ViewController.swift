//
//  ViewController.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/13/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let startScreenIndex = UserDefaults.standard.object(forKey: Commons.startScreenIndex) as? Int
        var startScreen = Screens.keyboardScreen.rawValue
        if(startScreenIndex != nil){
            startScreen = Settings.screenData[startScreenIndex!]["key"]!
        }
        
        self.performSegue(withIdentifier: startScreen, sender: self)
        
    }
}

