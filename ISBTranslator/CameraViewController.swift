//
//  CameraViewController.swift
//  ISBTranslator
//
//  Created by Tuan Nguyen on 5/19/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR

class CameraViewController: UIViewController, UITabBarDelegate, UIPopoverPresentationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, G8TesseractDelegate, SelectLanguageDelegate{
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var cannotDetectTextLabel: UILabel!
    
    var showTextResultView: UIView! = nil
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    var cameraButtonTapped = false
    
    var sourceLanguage: String = Languages.english.rawValue
    var targetLanguage: String = Languages.japanese.rawValue
    var targetLanguageIsActive: Bool = false
    var languageList: [String: String] = [:]
    var tesseractDataLanguageList: [String: String] = [:]
    
    var tesseract: G8Tesseract!
    var loading: UIActivityIndicatorView! = nil
    
    var rectOfBoxArr: [CGRect] = []
    var textSoure: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar?.delegate = self
        
        self.languageList = LanguageList
        self.tesseractDataLanguageList = TesseractDataLanguageList
        
        loading = self.addLoading()
        
        self.overlayView.isHidden = true
        self.cannotDetectTextLabel.isHidden = true
        self.cannotDetectTextLabel.text = Messages.errorDetectText
            
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = UIColor.white.cgColor
        
        tesseract = G8Tesseract(language: "eng")
        if tesseract != nil {
            tesseract.delegate = self
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.isNavigationBarHidden = true
        cameraButtonTapped = false
        prepareCamera()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.stopCaptureSession()
    }
    
    @IBAction func sourceLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = false
    }
    
    @IBAction func targetLanguageButtonTapped(_ sender: Any) {
        self.targetLanguageIsActive = true
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func changeLanguage(selectedItem: Int)
    {
        if(targetLanguageIsActive){//change target language
            self.targetLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.targetLanguage = Array(self.languageList.values)[selectedItem]
            if self.rectOfBoxArr.count > 0 && self.textSoure.count > 0 {
                if self.showTextResultView != nil{
                    self.showTextResultView.removeFromSuperview()
                }
                self.overlayView.isHidden = false
                self.loading.startAnimating()
                self.translation(textRecognized: self.textSoure)
            }
        }else{//change source language
            self.sourceLanguageButton.setTitle(Array(self.languageList.keys)[selectedItem], for: .normal)
            self.sourceLanguage = Array(self.languageList.values)[selectedItem]
            
            tesseract = G8Tesseract(language: Array(self.tesseractDataLanguageList.values)[selectedItem])
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.items?[0] == item) {
            self.performSegue(withIdentifier: Screens.keyboardScreen.rawValue, sender: self)
        }else if (tabBar.items?[1] == item) {
            self.performSegue(withIdentifier: Screens.voiceScreen.rawValue, sender: self)
        }else if(tabBar.items?[2] == item){
            showSettingMenu(sourView: self.tabBar)
        }
    }
        
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
        
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
        
    }
    
    func beginSession () {
        do {
            //Hide showing text result View
            DispatchQueue.main.async {
                self.overlayView.isHidden = true
                if self.showTextResultView != nil{
                    self.showTextResultView.removeFromSuperview()
                }
            }
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
            
        }catch {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            
            let screenSize = UIScreen.main.bounds
            
            let newRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height + 1)
            self.cameraView.layer.frame = newRect
            
            self.cameraView.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.cameraView.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            
            let queue = DispatchQueue(label: "captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
            self.cameraButton.isEnabled = true
            
        }
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        self.cameraButton.isEnabled = false
        self.cannotDetectTextLabel.isHidden = true
        
        self.textSoure = []
        self.rectOfBoxArr = []
        
        if cameraButtonTapped {
            cameraButtonTapped = false
            beginSession()
        } else{
            self.overlayView.isHidden = false
            self.loading.startAnimating()
            takePhoto = true
            cameraButtonTapped = true
            
        }
    }
    
    //Auto capture output
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if takePhoto {
            takePhoto = false
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    let screenSize = UIScreen.main.bounds
                    
                    self.stopCaptureSession()
                    let imageView = UIImageView(image: image)
                    
                    imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                    
                    self.cameraButton.isEnabled = true
                    
                    //Execute tesseract ocr
                    if self.tesseract != nil {
                        self.tesseract.image = imageView.image!.g8_blackAndWhite()
                        self.tesseract.maximumRecognitionTime = 30
                        self.tesseract.recognize()
                        let arrTextLine = self.tesseract.recognizedBlocks(by: G8PageIteratorLevel.textline)
                        
                        
                        for item in arrTextLine! {
                        
                            let line = item as? G8RecognizedBlock
                            
                            if(Int((line?.confidence)!) > 70 ){//get translated text with confidence > 70%
                                self.rectOfBoxArr.append(CGRect(x: ((line?.boundingBox.origin.x)! * screenSize.width) , y: ((line?.boundingBox.origin.y)! * screenSize.height - 6), width: (line?.boundingBox.width)! * screenSize.width, height: (line?.boundingBox.height)! * screenSize.height + 6))
                                
                                print((line?.boundingBox.origin.y)! * screenSize.height)
                                print((line?.boundingBox.height)! * screenSize.height)
                                print((line?.text)!)

                                
                                self.textSoure.append((line?.text)!)
                            }
                        }
                  
                        if(self.textSoure.count > 0){
                            self.translation(textRecognized: self.textSoure)
                        } else{
                            self.loading.stopAnimating()
                            self.cannotDetectTextLabel.text = Messages.errorDetectText
                            self.cannotDetectTextLabel.isHidden = false
                        }
                       
                    }
                }
            }            
        }
    }
    
    //This function return image with size 1920X1080
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: 1, orientation: .right)
            }
            
        }
        
        return nil
    }
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
    
    //Translate function with multiple lines text
    func translation(textRecognized: [String]){
        self.cannotDetectTextLabel.isHidden = true
        
        let translation = Translation()
        translation.sourceLanguage = self.sourceLanguage
        translation.targetLanguage = self.targetLanguage
        translation.textSource = textRecognized
        self.showTextResultView = UIView(frame: self.cameraView.frame)
        
        if self.sourceLanguage == self.targetLanguage { //don't call API translation for this case
            self.loading.stopAnimating()
            var count: Int = 0
            for translatedText in textSoure {
                self.createLabelTranslatedText(rect: self.rectOfBoxArr[count], text: translatedText)
                count += 1
            }
            
            self.overlayView.addSubview(self.showTextResultView)
        } else { //call API translation for this case sourceLanguage != targetLanguage
            if !Utilities().isInternetAvailable(){ //check internet contnection
                self.loading.stopAnimating()
                self.cannotDetectTextLabel.text = Messages.cannotConnectInternet
                self.cannotDetectTextLabel.isHidden = false
                showToast(message: Messages.cannotConnectInternet)
                return
            }
            
            //call translate function
            translation.textTranslationList(completion: { (translatedTextArr) in
                DispatchQueue.main.async {
                    self.loading.stopAnimating()
                    var count: Int = 0
                    for translatedTextItem in translatedTextArr {
                        let translation = translatedTextItem as? [String : Any]
                        
                        
                        let translatedText = translation?["translatedText"] as? String
                        self.createLabelTranslatedText(rect: self.rectOfBoxArr[count], text: translatedText!)
                        
                        count += 1
                        
                    }
                    self.overlayView.addSubview(self.showTextResultView)
                }
            })
        }
    }
    
    //create a lable to overlay text in image
    func createLabelTranslatedText(rect: CGRect, text: String) {
        let label = UILabel(frame: rect)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 1
        label.text = text
        label.textColor = UIColor.white
        //label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.showTextResultView.addSubview(label)

    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("\(tesseract.progress) | \(Date())")
    }


}
