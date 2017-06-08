//
//  Constant.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/14/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import Foundation


struct Commons {
    static let holidingTime: TimeInterval = 0.5
    static let borderWidth: CGFloat = 0.5
    static let boxRadius: CGFloat = 3.0
    static let headerHeight: CGFloat = 50.0
    static let startScreenIndex: String = "startScreenIndex"
}

struct StaticTexts {
    static let about: String = "About"
    static let startMode: String = "Start Mode"
    static let defaultScreen: String = "Camera"
    static let confirmText: String = "Confirm"
    static let aboutApp: String = "Translator App - Version "
    static let ISBCorporation: String = "© ISB Corporation. All Rights Reserved"
}


enum Screens: String {
    case keyboardScreen = "keyboardScreen"
    case voiceScreen = "voiceScreen"
    case cameraScreen = "cameraScreen"
    
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

let MenuSetting: [String: Int] = [
    "Settings" : 0,
    "History" : 1,
    "Help" : 2,
    "About" : 3
]


let SpeechLanguageList: [String: String] = [
    "English" : "en-EN",
    "Japanese" : "ja-JP",
    "Vietnamese" : "vi-VN"
]

let TesseractDataLanguageList: [String: String] = [
    "English" : "eng",
    "Japanese" : "jpn",
    "Vietnamese" : "vie"
]

struct LanguageCodes {
    static let English = SpeechLanguageList["English"]
}

struct Settings {
    static let tableCellMinHeight: CGFloat = 80
    static let stringFormatDate: String = "dd/MM/yyyy"
    static let spashScreenTimer: TimeInterval = 1.0
    static let views: [String] = ["settingView", "historyView", "helpView", "aboutView"]
    static let screenData: [[String:String]] = [["image": "camera-gray.png", "title": "Camera", "key": "cameraScreen"], ["image": "keyboard-gray", "title": "Keyboard", "key": "keyboardScreen"], ["image": "voice-gray.png", "title": "Voice", "key": "voiceScreen"]]
}


enum LanguagePopover: NSNumber {
    case width = 150
    case height = 130
}

struct Messages {
    static let cannotConnectInternet = "Can't connect to internet."
    static let cannotLoadContent = "Can't load content."
    static let noDataTranslation = "No translations. \n Translate something."
    static let errorSpeech = "Cannot recognize speech. \n Please try again."
    static let errorDetectText = "Cannot detect any text. \n Please try again."
    static let audioEngineNotInput = "Audio engine has no input node"
    static let unableRecognitionRequest = "Unable to create an SFSpeechAudioBufferRecognitionRequest object"
    static let areYouSure = "Are you sure to delete the history data?"
}
