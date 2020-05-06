//
//  UIColor+Externsion.swift
//  tryCleanCode
//
//  Created by eman shedeed on 2/9/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    //////
    static let appColor = UIColor(named:"AppColor")
      static let appGrayColor = UIColor(named:"AppGrayColor")
    static let locatemeBtnG1 = UIColor(named: "locatemeBtnG1")
    static let locatemeBtnG2 = UIColor(named: "locatemeBtnG1")
    static let dayCellGrayTextColor = UIColor(named: "dayCellGrayTextColor")

}
