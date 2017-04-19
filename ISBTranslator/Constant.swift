//
//  Constant.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/14/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import Foundation

let FirstScreen = "FirstScreen"

enum Screens: String {
    case keyboardScreen = "keyboardScreen"
    case voiceScreen = "voiceScreen"
    case cameraScreen = "camereScreen"
    
}

enum Languages: String {
    case english = "en"
    case japanese = "ja"
    case vietnamese = "vi"
}

let LanguageList: [String: String] = [
    "English" : "en",
    "Japanese" : "ja",
    "Vietnamese" : "vi"
]

enum LanguagePopover: NSNumber {
    case width = 150
    case height = 151
}


