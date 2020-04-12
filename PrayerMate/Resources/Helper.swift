//
//  Helper.swift
//  Ataba
//
//  Created by eman shedeed on 9/14/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit
import Toaster
import Photos
import SystemConfiguration
class Helper {
    
    class func showAlert(title: String, message: String, VC: UIViewController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "alertBtnTitle".localized, style: .cancel, handler: nil)
        
        alertVC.addAction(ok)
        VC.present(alertVC, animated: true, completion: nil)
    }
    
    class func showToast(message: String) {
        
        let toast = Toast(text: message, delay: 0.5 , duration: Delay.short)
        toast.show()
    }
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        options.isNetworkAccessAllowed=true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
        
    }
    class func findDateDiff(time1Str: String, time2Str: String,isNextDayFajr: Bool) -> String {
        let timeformatter = DateFormatter()
        timeformatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        timeformatter.dateFormat = "hh:mm:ss a"

        guard let time1 = timeformatter.date(from:time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        var hour = interval / 3600;
        var minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        var second = (interval.truncatingRemainder(dividingBy: 60))
        if(isNextDayFajr){
            hour = hour + 24
            minute = minute + 60
            second = second + 60
        }
        let intervalInt = Int(interval)
        let hourString = String(Int(hour)).count == 1 ? "0" + String(Int(hour)) : String(Int(hour))
        let minuteString = String(Int(minute)).count == 1 ? "0" + String(Int(minute)) : String(Int(minute))
         let secondString = String(Int(second)).count == 1 ? "0" + String(Int(second)) : String(Int(second))
     
        return "\(hourString):\(minuteString):\(secondString)"
    }
}
class TintedSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 13.0, *) {
            for subview in subviews {
                if let selectedImageView = subview.subviews.last(where: { $0 is UIImageView }) as? UIImageView,
                    let image = selectedImageView.image {
                    selectedImageView.image = image.withRenderingMode(.alwaysTemplate)
                    break
                }
            }
        }
    }
    
}
