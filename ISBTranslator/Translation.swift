//
//  Translation.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import Foundation
import UIKit

class Translation{
    
    var API_Key: String = Config.API_Key.rawValue
    var API_Url: String = Config.HttpTranslateURL.rawValue
    
    var sourceLanguage: String!
    var targetLanguage: String!
    var textSource: [String]!
    
    init() {
    }
    private func getStringAPI() -> String{
        var textSourceString: String = ""
        
        for textSourceItem in textSource {
            let textSourceWithPercentEscapes = textSourceItem.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as String
            
            textSourceString += "&q=\(textSourceWithPercentEscapes)"
        }
        
        return "\(API_Url as String)key=\(API_Key as String)\(textSourceString as String)&source=\(sourceLanguage as String)&target=\(targetLanguage as String)"
    }
    
    func textTranslationList(completion: @escaping (_ resultText: [NSDictionary])->()) -> Void
    {
        
        let urlString = getStringAPI()
        
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                //todo: will update for this
                print("translate error: \(error!.localizedDescription)")
                
            } else {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    let jsonData = json?["data"] as? [String : Any]
                    
                    //let translations = jsonData?["translations"] as? [NSDictionary]
                    
                    //let translation = translations?.first as? [String : Any]
                    
                    //                    if let translatedText = translation?["translatedText"] as? String{
                    //                        completion(translatedText)
                    //                    }
                    if let translations = jsonData?["translations"] as? [NSDictionary]{
                        completion(translations)
                    }
                    else{
                        //todo: will update for this
                        print("translate error")
                    }
                    
                    
                    
                } catch {
                    //todo: will update for this
                    print("error in JSONSerialization")
                    
                }
                
            }
            
        })
        task.resume()
    }

    
    func textTranslation(completion: @escaping (_ resultText: String)->()) -> Void
    {
        textTranslationList { (translatedTextArr) in
            let translation = translatedTextArr.first as? [String : Any]
            if let translatedText = translation?["translatedText"] as? String{
                completion(translatedText)
            }
            else{
                //todo: will update for this
                print("translate error")
            }
        }        
    }
}
