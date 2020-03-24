//
//  UIString+Extension.swift
//  tryCleanCode
//
//  Created by eman shedeed on 2/9/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//
import UIKit
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    //Localization
    var localized: String {
           return NSLocalizedString(self, comment: "")
       }
        public var EnToARDigits : String {
            let englishNumbers = ["0": "٠","1": "١","2": "٢","3": "٣","4": "٤","5": "٥","6": "٦","7": "٧","8": "٨","9": "٩"]
            var txt = self
            englishNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
            return txt
    }

}

