//
//  UIFontExtension.swift
//  Ataba
//
//  Created by eman shedeed on 8/20/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
/*
enum AppFontNames:String {
    
    case montserratRegular = "Montserrat-Regular" // font name
    
    case montserratMedium = "Montserrat-Medium"
    
    case montserratBold = "Montserrat-Bold"
    
  /*  case nunitoSansRegular="NunitoSans-Regular"
    case nunitoSansBold="NunitoSans-Bold"*/
    case robotoRegular="Roboto-Regular"
    case robotoMedium="Roboto-Medium"
    case robotoBold="Roboto-Bold"
    // case LTBukraBold = "29LTBukra-Bold"
}





enum AppFontSize: CGFloat {
    case S = 10
    
    case M = 12
    
    case L = 14
    
    case XL = 16
    
    case XXL = 18
    
    case XXXL = 20
    
    case XXXXL = 22
    
    case XXXXXL = 24
    
}
extension UIFont {
    static func customAppFont(name: AppFontNames, size: AppFontSize) -> UIFont {
        let font = UIFont(name: name.rawValue, size: size.rawValue)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    class func appRegularFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.montserratRegular.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    class func appMediumFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.montserratMedium.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.montserratBold.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
////////////
    class func appRobotoRegularFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.robotoRegular.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    class func appRobotoBoldFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.robotoBold.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    class func approbotoMediumdFontWith( size:CGFloat ) -> UIFont{
        let font = UIFont(name: AppFontNames.robotoMedium.rawValue , size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
}
*/
extension UILabel{
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
  /*
    @IBInspectable
    var appRegularFontWithSize: CGFloat{
        set{
            self.font = UIFont.appRegularFontWith(size: newValue)
        }
        get{
            return self.appRegularFontWithSize
        }
    }
    @IBInspectable
    var appMediumFontWithSize: CGFloat{
        set{
            self.font = UIFont.appMediumFontWith(size: newValue)
        }
        get{
            return self.appMediumFontWithSize
        }
    }
    @IBInspectable
    var appBoldFontWithSize: CGFloat{
        set{
            self.font = UIFont.appBoldFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
    ///
    @IBInspectable
    var appRobotoRegularFontWith: CGFloat{
        set{
            self.font = UIFont.appRobotoRegularFontWith(size: newValue)
        }
        get{
            return self.appRobotoRegularFontWith
        }
    }
    @IBInspectable
    var appRobotoBoldFontWith: CGFloat{
        set{
            self.font = UIFont.appRobotoBoldFontWith(size: newValue)
        }
        get{
            return self.appRobotoBoldFontWith
        }
    }
    @IBInspectable
    var approbotoMediumdFontWith: CGFloat{
        set{
            self.font = UIFont.approbotoMediumdFontWith(size: newValue)
        }
        get{
            return self.approbotoMediumdFontWith
        }
    }*/
 
}
extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
extension UIButton{
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = self.titleLabel?.attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                self.titleLabel?.text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            self.titleLabel?.attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = self.titleLabel?.attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
    /*
    @IBInspectable
    var appRegularFontWithSize: CGFloat{
        set{
            self.titleLabel?.font = UIFont.appRegularFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
    @IBInspectable
    var appMediumFontWithSize: CGFloat{
        set{
            self.titleLabel?.font = UIFont.appMediumFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
    @IBInspectable
    var appBoldFontWithSize: CGFloat{
        set{
            self.titleLabel?.font = UIFont.appBoldFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }*/
    
}
/*
extension UITextField{
    
    @IBInspectable
    var appRegularFontWithSize: CGFloat{
        set{
            self.font = UIFont.appRegularFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
    @IBInspectable
    var appMediumFontWithSize: CGFloat{
        set{
            self.font = UIFont.appMediumFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
    @IBInspectable
    var appBoldFontWithSize: CGFloat{
        set{
            self.font = UIFont.appBoldFontWith(size: newValue)
        }
        get{
            return self.appBoldFontWithSize
        }
    }
     func addBottomBorder(){
         let bottomLine = CALayer()
         bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
         borderStyle = .none
         layer.addSublayer(bottomLine)
     }
 }
*/
