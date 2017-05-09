//
//  Constant.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/14/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
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

let SpeechLanguageList: [String: String] = [
    "English" : "en-EN",
    "Japanese" : "ja-JP",
    "Vietnamese" : "vi-VN"
]

struct LanguageCodes {
    static let English = SpeechLanguageList["English"]
}


enum LanguagePopover: NSNumber {
    case width = 150
    case height = 151
}

struct Messages {
    static let errorSpeech = "Cannot recognize speech. \n Please try again."
    static let audioEngineNotInput = "Audio engine has no input node"
    static let unableRecognitionRequest = "Unable to create an SFSpeechAudioBufferRecognitionRequest object"
}
