//
//  UILabel+Extension.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/16/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//
import UIKit
extension UILabel{
   @IBInspectable
    var localizedText:String{
        get{
            return text ?? ""
        }
        set{
            text = NSLocalizedString(newValue, tableName: nil, bundle: Bundle.main, comment: "")
        }
    }

}
extension UIButton {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.setTitle(newValue.localized, for: .normal)
        }
    }
}
