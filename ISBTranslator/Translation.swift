//
//  Translation.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/18/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import Foundation

class Translation{
    
    var API_Key: String = Config.API_Key.rawValue
    var API_Url: String = Config.HttpTranslateURL.rawValue
    
    var sourceLanguage: String!
    var targetLanguage: String!
    var textSource: String!
    
    init() {
    }
    private func getStringAPI() -> String{
        let textSourceWithPercentEscapes = textSource.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as String
        return "\(API_Url as String)key=\(API_Key as String)&q=\(textSourceWithPercentEscapes as String)&source=\(sourceLanguage as String)&target=\(targetLanguage as String)"
    }
    
    func textTranslation(completion: @escaping (_ resultText: String)->()) -> Void
    {
       
        let urlString = getStringAPI()
        
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                //todo: will update for this
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    //todo: will update this function
                    if let data = data {
                        if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            if let jsonData = json["data"] as? [String : Any] {
                                if let translations = jsonData["translations"] as? [NSDictionary] {
                                    if let translation = translations.first as? [String : Any] {
                                        if let translatedText = translation["translatedText"] as? String {                                            completion(translatedText)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    //todo: will update for this
                    print("error in JSONSerialization")
                    
                }
                
            }
            
        })
        task.resume()
    }
}
