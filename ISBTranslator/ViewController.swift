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
        
        let firstScreen = UserDefaults.standard.object(forKey: FirstScreen)
        if(firstScreen == nil){
            self.performSegue(withIdentifier: Screens.keyboardScreen.rawValue, sender: self)
        }
        
    }
}

