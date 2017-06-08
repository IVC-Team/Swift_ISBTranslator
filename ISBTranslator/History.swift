//
//  HistoryModel.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/12/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class HistoryModel: Object{
    dynamic var id = 0
    dynamic var createdAt = Date()
    dynamic var sourceLanguage = ""
    dynamic var targetLanguage = ""
    dynamic var sourceText = ""
    dynamic var translatedText = ""
    dynamic var selected = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: Array = Array(realm.objects(HistoryModel.self).sorted(byKeyPath: "id"))
        let last = RetNext.last
        if RetNext.count > 0 {
            let id = last?.id
            return id! + 1
        } else {
            return 1
        }
    }
}

class History {
    func getHistoryList() -> [HistoryModel]
    {
        let realm = try! Realm()
        return Array(realm.objects(HistoryModel.self).sorted(byKeyPath: "createdAt", ascending: false))
    }
    
    func add(sourceLanguage: String, targetLanguage: String, sourceText: String, translatedText: String)
    {
        let historyModel = HistoryModel()
        historyModel.id = historyModel.incrementaID()
        historyModel.sourceLanguage = sourceLanguage
        historyModel.targetLanguage = targetLanguage
        historyModel.sourceText = sourceText
        historyModel.translatedText = translatedText
        
        let realm = try! Realm()
        try! realm.write {
            let history = realm.objects(HistoryModel.self).filter("sourceLanguage == %@ and sourceText == %@ and targetLanguage == %@ and translatedText == %@" , sourceLanguage, sourceText, targetLanguage, translatedText).first
            if (history == nil) {
                realm.add(historyModel)
            } else {
                history?.createdAt = Date()
                realm.add(history!, update: true)
            }
        }
        
    }
    
    func delele(historyItem: HistoryModel)
    {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(historyItem)
        }
        
    }
}
