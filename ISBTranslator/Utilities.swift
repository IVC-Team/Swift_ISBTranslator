//
//  Utilities.swift
//  ISBTranslator
//
//  Created by IVC-VIETNAM on 4/19/17.
//  Copyright © 2017 ISB. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

public class Utilities{
    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage
    {
        var scaleSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height{
            scaleFactor = image.size.height/image.size.width
            scaleSize.width = maxDimension
            scaleSize.height = scaleSize.width * scaleFactor
        }else{
            scaleFactor = image.size.width/image.size.height
            scaleSize.height = maxDimension
            scaleSize.width = scaleSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaleSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaleSize.width, height: scaleSize.height))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaleImage!
    }
    
    func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        let newImage: UIImage = UIImage(cgImage: imageRef, scale: 1, orientation: image.imageOrientation)
        
        return newImage
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
