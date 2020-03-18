//
//  UserDefaultsUtility.swift
//  Adahi
//
//  Created by aboushady on 4/7/19.
//  Copyright © 2019 LinkDevelopment. All rights reserved.
//

import Foundation

class UserDefaultsUtility {
    
    static func saveAppLanguage(language:AppLanguages) {
        UserDefaults.standard.set(language.rawValue, forKey:"appLanguage" )
    }
    
    static func loadAppCurrentLanguage() -> AppLanguages? {
        return AppLanguages(rawValue: UserDefaults.standard.string(forKey: "appLanguage") ?? "")
    }
    
}
