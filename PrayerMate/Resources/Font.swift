//
//  Font.swift
//  tryCleanCode
//
//  Created by eman shedeed on 2/9/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//
import UIKit
public protocol isFont {
    var family: String { get }
    
    var style: String { get }
}
extension isFont {
    public func size(_ size: CGFloat) -> UIFont {
        let fontName = "\(family)-\(style)"
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
public struct FontBook {
    
    public enum Montserrat: String, isFont {
        public var family: String {
            return "Montserrat"
        }
        
        public var style: String {
            return self.rawValue.capitalizingFirstLetter()
        }
        
        case bold
//        case demiBold
//        case heavy
        case medium
        case regular
        
    }
    
    public enum Roboto: String, isFont {
        public var family: String {
            return "Roboto"
        }
        
        public var style: String {
            return self.rawValue.capitalizingFirstLetter()
        }
        
         case bold
        //        case demiBold
        //        case heavy
                case medium
                case regular
        
    }
}
public extension FontBook {
 static let subTitle = Montserrat.medium
 static let title = Montserrat.bold.size(18)
}
