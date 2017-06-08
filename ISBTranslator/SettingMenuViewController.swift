//
//  SettingMenuViewController.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/10/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit

protocol SettingMenuDelegate {
    func changeItem(selectedItem: Int)
}

class SettingMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var menuSettings: [String: Int] = [:]
    
    @IBOutlet weak var menuItem: UITableView!
    
    var delegate: SettingMenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuSettings = MenuSetting
        self.menuItem.delegate =  self
        self.menuItem.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.text =  Array(self.menuSettings.keys)[indexPath.item]
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) {
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.delegate != nil){
                        self.dismiss(animated: true, completion: nil)
            delegate.changeItem(selectedItem: indexPath.item)

        }
        //self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "historyView", sender: nil)
        //let historyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyView") as! HistoryViewController
        //self.navigationController?.showDetailViewController(historyView, sender: nil)
        //historyView.
        
        //self.present(historyView, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "historyView", sender: nil)
        
//        let test = self
//        
//        self.dismiss(animated: true) { 
//            let historyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyView") as! HistoryViewController
//            //self.navigationController?.showDetailViewController(historyView, sender: nil)
//            //historyView.
//            
//            test.present(historyView, animated: true, completion: nil)
//        }
    }
    
}
