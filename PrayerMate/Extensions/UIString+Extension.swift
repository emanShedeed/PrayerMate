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
}

