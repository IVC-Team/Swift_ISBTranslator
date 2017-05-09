//
//  VoiceViewController.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 5/4/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import Speech

class VoiceViewController: UIViewController, UIPopoverPresentationControllerDelegate, SFSpeechRecognizerDelegate, UITabBarDelegate, SelectLanguageDelegate {

    @IBOutlet weak var voiceInputTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var viewTextResultLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    private var speechRecognizer = SFSpeechRecognizer()!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    weak var timer: Timer?
    var sourceLanguage: String = Languages.english.rawValue
    var targetLanguage: String = Languages.japanese.rawValue
    var targetLanguageIsActive: Bool = false
    var languageList: [String: String] = [:]
    var speechLanguageList: [String: String] = [:]
    var loading: UIActivityIndicatorView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.languageList = LanguageList
        self.speechLanguageList = SpeechLanguageList
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: LanguageCodes.English!))!
        
        microphoneButton.isEnabled = false
        
        speechRecognizer.delegate = self
        
        self.tabBar?.delegate = self
        
        loading = self.addLoading()
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied, .restricted, .notDetermined:
                isButtonEnabled = false
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectLanguage" {
            let popoverViewController = segue.destination as! SelectLanguageViewController
            popoverViewController.delegate = self
            popoverViewController.preferredContentSize = CGSize(width: LanguagePopover.width.rawValue as! CGFloat, height:LanguagePopover.height.rawValue as! CGFloat)
            popoverViewController.popoverPresentationController?.delegate = self
            popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            popoverViewController.popoverPresentationController?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.items?[0] == item) {
            self.performSegue(withIdentifier: Screens.keyboardScreen.rawValue, sender: self)
        }
    }
    
    func changeLanguage(selectedItem: Int)
    {
        if(targetLanguageIsActive){
            self.targetLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.targetLanguage = Array(self.languageList.values)[selectedItem]
        }else{
            self.sourceLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.sourceLanguage = Array(self.languageList.values)[selectedItem]
            
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Array(self.speechLanguageList.values)[selectedItem]))!
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            stopRecording()
        } else {
            startTimer(time: ConfigTimeInterval.SpeechFirstStart.rawValue)
            startRecording()
            microphoneButton.backgroundColor = UIColor.secondColor
        }
    }
    
    @IBAction func sourceLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = false
    }
    
    @IBAction func targetLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = true
    }
    
    @IBAction func switchLanguageButtonTapped(_ sender: Any) {
        let sourceTemp = sourceLanguageButton.title(for: UIControlState.normal)
        let tergetTemp = targetLanguageButton.title(for: UIControlState.normal)
        
        self.targetLanguageButton.setTitle(sourceTemp, for: .normal)
        self.targetLanguage = self.languageList[sourceTemp!]!
        
        self.sourceLanguageButton.setTitle(tergetTemp, for: .normal)
        self.sourceLanguage = self.languageList[tergetTemp!]!
        
        self.voiceInputTextView.text = self.viewTextResultLabel.text
        self.translation(textRecognized: self.voiceInputTextView.text)
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: self.speechLanguageList[tergetTemp!]!))!
    }

    
    func stopRecording(){
        audioEngine.stop()
        recognitionRequest?.endAudio()
        microphoneButton.isEnabled = false
        microphoneButton.backgroundColor = UIColor.transparent
    }
    
    func startRecording() {
        
        self.voiceInputTextView.text = ""
        self.viewTextResultLabel.text = ""
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            showMessage(message: Messages.errorSpeech)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError(Messages.audioEngineNotInput)
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError(Messages.unableRecognitionRequest)
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.voiceInputTextView.text = result?.bestTranscription.formattedString
                self.stopTimer()
                self.startTimer(time: ConfigTimeInterval.SpeechRecording.rawValue)

                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.stopTimer()
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
                
                self.translation(textRecognized: self.voiceInputTextView.text)
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            showMessage(message: Messages.errorSpeech)
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func translation(textRecognized: String) {
        
        if textRecognized.isEmpty{
            return
        }
        
        let translation = Translation()
        translation.sourceLanguage = self.sourceLanguage
        translation.targetLanguage = self.targetLanguage
        translation.textSource = textRecognized
        
        self.loading.startAnimating()
        
        translation.textTranslation(completion: { (translatedText) in
            DispatchQueue.main.sync {
                self.loading.stopAnimating()
                self.viewTextResultLabel.text = translatedText
            }
        })
    }
    
    func startTimer(time: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { [weak self] _ in
            self?.stopRecording()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }

}
