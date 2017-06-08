//
//  HistoryViewController.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/10/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, CheckboxDelegate{
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkAllButton: Checkbox!
    @IBOutlet weak var historyTableView: UITableView!

    var isEditMode: Bool = false
    var checkAll: Bool = false
    var historyList: [HistoryModel] = []
    let history = History()
    var indexChanged: [Int: Bool] = [:]
    
    var delegate: SettingMenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.backItem?.title = ""

        historyList = history.getHistoryList()
        
        self.historyTableView.delegate =  self
        self.historyTableView.dataSource = self
        
        deleteButton.isHidden = true
        checkAllButton.isHidden = true
        checkAllButton.layer.borderWidth = 1
        checkAllButton.layer.borderColor = UIColor.white.cgColor
        
        self.historyTableView.estimatedRowHeight = Settings.tableCellMinHeight
        self.historyTableView.rowHeight = UITableViewAutomaticDimension
        
        self.historyTableView.setNeedsLayout()
        self.historyTableView.layoutIfNeeded()
        
        self.noDataLabel.text = Messages.noDataTranslation
        self.checkDataTranslation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        longPressGesture.minimumPressDuration = Commons.holidingTime //holding time is 0.5 minute
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        let historyItem = historyList[indexPath.item]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Settings.stringFormatDate
        let dateString = dateFormatter.string(from:historyItem.createdAt as Date)
        cell.createDate.text = dateString
        cell.sourceLanguage.text = historyItem.sourceLanguage.uppercased()
        cell.targetLanguage.text = historyItem.targetLanguage.uppercased()
        cell.sourceText.text = historyItem.sourceText
        cell.resultText.text = historyItem.translatedText
        
        cell.selectItem.index = indexPath.item
        cell.selectItem.isHidden = !isEditMode
        cell.selectItem.delegate = self
        
        cell.cellView.layer.borderColor = UIColor.lightColor.cgColor
        cell.cellView.layer.borderWidth = Commons.borderWidth
        cell.cellView.layer.cornerRadius = Commons.boxRadius
        
        cell.cellHeader.layer.cornerRadius = Commons.boxRadius
        
        //Do not reset the value unless changed
        if checkAll {
            indexChanged[indexPath.item] = checkAllButton.isChecked
            
            if cell.selectItem.isChecked != checkAllButton.isChecked{
                cell.selectItem.isChecked = checkAllButton.isChecked
            }
            
            if indexPath.item + 1 == historyList.count {
                checkAll = false
            }

        } else{
            let value = indexChanged[indexPath.item]
            if (value != nil  && indexChanged.count > 0) {
                if cell.selectItem.isChecked != value {
                    cell.selectItem.isChecked = value!
                }
            } else{
                if cell.selectItem.isChecked != false{
                    cell.selectItem.isChecked = false
                }
            }
            
        }
        cell.addGestureRecognizer(longPressGesture)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            let cell = self.historyTableView.cellForRow(at: indexPath) as? HistoryTableViewCell
            indexChanged[indexPath.item] = !(cell?.selectItem.isChecked)!
            if (cell?.selectItem.isChecked)! {
                checkToCloseEditMode()
            }
            historyTableView.reloadData()
            
        }
       
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        for index in Array(indexChanged.keys).sorted(by: >) {
            if indexChanged[index]! {
                let historyItem = historyList[index]
                history.delele(historyItem: historyItem)
                indexChanged.removeValue(forKey: index)
                historyList.remove(at: index)
            }
        }
        checkToCloseEditMode()
        historyTableView.reloadData()
        checkDataTranslation()
    }
 
    @IBAction func checkAllButtonTapped(_ sender: Any) {
        checkAllButton.setBorder(color: UIColor.white) //reset border color to checkbox
        checkAllButton.checkedBorderShow = true //show border when checkbox is checked
        
        checkAll = true
        
        if checkAllButton.isChecked{
            isEditMode = false
            checkAllButton.isHidden = true
            deleteButton.isHidden = true
        }
        
        historyTableView.reloadData()
        
        
        //checkAll = false
        
    }
    
    //Tap & Hold Action for table item
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let cell = sender.view as! HistoryTableViewCell
            let indexPath = historyTableView.indexPath(for: cell)
            var selected: Bool
            
            //if let index = indexPath {
                if !isEditMode {
                    isEditMode = true
                    deleteButton.isHidden = false
                    checkAllButton.isHidden = false
                    selected = true
                    
                } else{
                    selected = !(cell.selectItem.isChecked)
                }
            
                indexChanged[(indexPath?.item)!] = selected
                //cell.selectItem.isChecked = selected
            
            
                if !selected {
                    checkToCloseEditMode()
                }
            
                self.historyTableView.reloadData()
            
        }
    }
    
    //Count selected item
    func countSelectedItem() -> Int{
        var result: Int = 0
        for itemChanged in indexChanged {
            if itemChanged.value {
                result+=1
            }
        }
        return result
    }
    
    //This func will be call after clicking the checkbox
    func checkboxClickCallBack(selected: Bool, index: Int?) {
        if index != nil{
            indexChanged[index!] = selected
        }
        
        //Only close editing mode when checkbox is unchecked
        if !selected {
            checkToCloseEditMode()
            historyTableView.reloadData()
        }
    }
    
    //Checking if no item is selected, it will close the editing mode
    func checkToCloseEditMode()
    {
        let countSelectedItem = self.countSelectedItem()
        if countSelectedItem <= 0 && isEditMode {
            isEditMode = false
            checkAllButton.isHidden = true
            deleteButton.isHidden = true
        }

    }
    
    //Check and show message data emply or not
    func checkDataTranslation() {
        if historyList.count <= 0 {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
    }

}
