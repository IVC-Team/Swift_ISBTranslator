//
//  SelectLanguageViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 4/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

protocol SelectLanguageDelegate {
    func changeLanguage(selectedItem: Int)
}

class SelectLanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var languageList: [String: String] = [:]
    
    @IBOutlet weak var languageTable: UITableView!
    
    var delegate: SelectLanguageDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.languageList = LanguageList
        self.languageTable.delegate =  self
        self.languageTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.text =  Array(self.languageList.keys)[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.delegate != nil){
            delegate.changeLanguage(selectedItem: indexPath.item)
            self.dismiss(animated: true, completion: nil)
        }
    }



}
