//
//  SettingViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/16/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var startModeTableView: UITableView!
    @IBOutlet weak var clearHistoryButton: UIButton!
    
    var startScreen = StaticTexts.defaultScreen
    
    var startModeData: [[String:String]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startModeData = Settings.screenData
        
        self.startModeTableView.delegate =  self
        self.startModeTableView.dataSource = self
        self.startModeTableView.sectionHeaderHeight = Commons.headerHeight
        
        view.backgroundColor = UIColor.lightColorBackground
        
        clearHistoryButton.layer.borderColor = UIColor.lightColor.cgColor
        clearHistoryButton.layer.borderWidth = Commons.borderWidth
        
        if UserDefaults.standard.object(forKey: Commons.startScreenIndex) != nil {
            let startScreenIndex = UserDefaults.standard.object(forKey: Commons.startScreenIndex) as? Int
            startScreen = startModeData[startScreenIndex!]["title"]!
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.startModeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "radioCell", for: indexPath) as! RadioTableViewCell

        cell.titleLabel?.text = startModeData[indexPath.item]["title"]
        cell.imageItemView?.image = UIImage(named: startModeData[indexPath.item]["image"]!)
        cell.imageItemView?.contentMode = UIViewContentMode.center
        
        if startScreen == startModeData[indexPath.item]["title"] {
            cell.selectedButton.isHidden = false
        } else {
            cell.selectedButton.isHidden = true
        }
        
        let border = CALayer()
        border.backgroundColor = UIColor.lightColor.cgColor
        border.frame = CGRect(x:0,y: 0, width:cell.frame.size.width, height: Commons.borderWidth)
        cell.layer.addSublayer(border)
        
        if indexPath.item == startModeData.count - 1 {
            let borderBottom = CALayer()
            borderBottom.backgroundColor = UIColor.lightColor.cgColor
            borderBottom.frame = CGRect(x:0,y: cell.frame.size.height - Commons.borderWidth, width:cell.frame.size.width, height: Commons.borderWidth)
            cell.layer.addSublayer(borderBottom)
        }
        
        //cell.imageView?. = UIColor.mainColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startScreen = startModeData[indexPath.item]["title"]!
        UserDefaults.standard.set(indexPath.item, forKey: Commons.startScreenIndex)
        UserDefaults.standard.synchronize()
        startModeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return StaticTexts.startMode
        }
        
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(descriptor: UIFontDescriptor.init(), size: 17)
        header.backgroundColor = UIColor.lightColorBackground
    }

    @IBAction func clearHistoryButtonTapped(_ sender: Any) {
       self.showConfirmMessage(title: Messages.areYouSure, message: "") {
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
        
    }
}
