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
import Apollo
import SystemConfiguration
class Helper {
    
    class func showAlert(title: String, message: String, VC: UIViewController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
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
    class func saveUserDetails(userInfo: [String : Any]) {
        
        let userDefault = UserDefaults.standard
        var user = [String: Any]()
        
        if Helper.getUserDetails().count != 0 {
            
            user = Helper.getUserDetails()
        }
        if let id = userInfo["userID"]{
            user["userID"] = id
        }
        if let name = userInfo["userName"]{
            user["userName"] = name
        }
        if let email = userInfo["userEmail"]{
            user["userEmail"] = email
        }
        if let phone = userInfo["userPhone"]{
            user["userPhone"] = phone
        }
        if let havePassword = userInfo["havePassword"]{
            user["havePassword"] = havePassword
        }
        if let profileImage = userInfo["profileImage"]{
            user["profileImage"] = profileImage
        }
        user["accessToken"]=userInfo["accessToken"]
        user["refreshToken"]=userInfo["refreshToken"]
        
        userDefault.setValue(user, forKey: "user")
        userDefault.synchronize()
    }
    class func getUserDetails() -> [String: Any] {
        
        let userDefault = UserDefaults.standard
        var user = [String: Any]()
        
        if userDefault.value(forKey: "user") != nil {
            
            user = userDefault.value(forKey: "user") as! [String: Any]
        }
        return user
    }
    class func swipeCellAnimation(cell : UITableViewCell!, tableView:UITableView, lastBtnImageName:String){
        cell.clipsToBounds = false
        let editActionBtn = UIButton(frame: CGRect(x: (cell.frame.width) , y: 0, width: 70, height: cell.frame.height ))
        let deleteActionBtn = UIButton(frame: CGRect(x: (cell.frame.width) + 70 , y: 0, width: 70, height: cell.frame.height ))
        let hideActionBtn = UIButton(frame: CGRect(x: (cell.frame.width) + 140 , y: 0, width: 70, height: cell.frame.height ))
        editActionBtn.setImage(UIImage(named: "edit"), for: .normal)
        hideActionBtn.setImage(UIImage(named: lastBtnImageName), for: .normal)
        deleteActionBtn.setImage(UIImage(named: "delete"), for: .normal)
        editActionBtn.backgroundColor = UIColor(rgb: 0xEA961E)
        deleteActionBtn.backgroundColor = UIColor(rgb: 0xEA961E)
        hideActionBtn.backgroundColor = UIColor(rgb: 0xEA961E)
        cell.addSubview(hideActionBtn)
        cell.addSubview(deleteActionBtn)
        cell.addSubview(editActionBtn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            UIView.animate(withDuration: 0.7 , animations: {
                tableView.isUserInteractionEnabled=false
                cell.frame = CGRect(x: cell.frame.origin.x - 210, y: cell.frame.origin.y, width: cell.bounds.size.width , height: cell.bounds.size.height)
                
            }) { (finished) in
                UIView.animate(withDuration: 0.7, delay: 0.3, options: .allowUserInteraction, animations: {
                    cell.frame = CGRect(x: cell.frame.origin.x + 210, y: cell.frame.origin.y, width: cell.bounds.size.width , height: cell.bounds.size.height)
                    
                }) { (result) in
                    hideActionBtn.removeFromSuperview()
                    editActionBtn.removeFromSuperview()
                    deleteActionBtn.removeFromSuperview()
                    cell.clipsToBounds=true
                    tableView.isUserInteractionEnabled=true
                    
                }
            }
        }
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
