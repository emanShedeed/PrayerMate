//
//  RoundedButton.swift
//  Ataba
//
//  Created by eman shedeed on 7/31/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//


import UIKit
@IBDesignable
class RoundedButton:UIButton{
    //Border Width
    @IBInspectable
    var borderWidth: CGFloat = 0.5 { didSet { setNeedsDisplay() } }
    //Border Color
    @IBInspectable
    var borderColor: UIColor = UIColor(rgb: 0xBCE0FD) { didSet { setNeedsDisplay() } }
    //corner Radius
    @IBInspectable  var cornerRadius: CGFloat = 22.5 { didSet { setNeedsDisplay() } }
 
    // to pass values to control attriputes
    override func draw(_ rect: CGRect) {
        layer.borderWidth=borderWidth
        layer.borderColor=borderColor.cgColor
        layer.masksToBounds = true
     //   layer.cornerRadius = abs(CGFloat(Int(cornerRadius * 100)) / 100)
          layer.cornerRadius = cornerRadius
    }
    
}
