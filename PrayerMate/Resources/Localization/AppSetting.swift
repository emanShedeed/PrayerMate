//
//  AppLanguage.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/16/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit

enum AppLanguages:String{
    case en = "en"
//    case fr = "fr-FR"
    case ar = "ar-SA"
}

class AppSetting {
    
    static  var shared = AppSetting()
    private var currentLanguage:AppLanguages?
    
    private init(){}
    
    func getCurrentLanguage() -> AppLanguages? {
        guard let _ = currentLanguage else{return
            UserDefaultsUtility.loadAppCurrentLanguage()

        }
        return currentLanguage
    }
    
    func setCurrentLanguage(language:AppLanguages) {
        UserDefaultsUtility.saveAppLanguage(language:language)
        currentLanguage = language
    }
}
