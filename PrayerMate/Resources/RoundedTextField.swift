//
//  CustomTextField.swift
//  Ataba
//
//  Created by eman shedeed on 7/31/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedTextField:UITextField{
    //Border Width
    @IBInspectable
    var borderWidth: CGFloat = 0.5 { didSet { setNeedsDisplay() } }
    //Border Color
    @IBInspectable
    var borderColor: UIColor = UIColor(rgb: 0xEAEAEA){ didSet { setNeedsDisplay() } }
    //corner Radius
    @IBInspectable  var cornerRadius: CGFloat = 22.5 { didSet { setNeedsDisplay() } }
    //padding Left
    @IBInspectable var paddingLeftCustom: CGFloat = 10 { didSet { setNeedsDisplay() } }
    @IBInspectable var placeHolderColor: UIColor=UIColor(rgb: 0x333333){ didSet { setNeedsDisplay() } }
    //padding Right
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    // to pass values to control attriputes
    override func draw(_ rect: CGRect) {
        layer.borderWidth=borderWidth
        layer.borderColor=borderColor.cgColor
        layer.masksToBounds = true
        // layer.cornerRadius = abs(CGFloat(Int(cornerRadius * 100)) / 100)
        layer.cornerRadius = cornerRadius
        leftView=UIView(frame: CGRect(x: 0, y: 0, width: paddingLeftCustom, height: frame.size.height))
        leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
    }
    
}
