//
//  SplashVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/6/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
final class SplashPresenter{
    /**
     Call this function for setup User Defaults for first use of the App
     - Parameters:
     
     ### Usage Example: ###
     ````
     SplashVCPresenter().setupUserDefaults()
     
     ````
     */
    func setupUserDefaults(){
        if  UserDefaults.standard.value(forKey: UserDefaultsConstants.automaticAdjustBufferToggle) == nil{
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.automaticAdjustBufferToggle)
        }
      
        if  UserDefaults.standard.value(forKey: UserDefaultsConstants.choosenCalendars) == nil{
            UserDefaults.standard.set([0], forKey: UserDefaultsConstants.choosenCalendars)
        }
        
        if  UserDefaults.standard.value(forKey: UserDefaultsConstants.prayerTimesBufferArray) == nil{
            
            let prayerTimesBufferArray =
                [
                    PrayerTimeBuffer(type:"M",before:15,after:15),
                    PrayerTimeBuffer(type:"M",before:15,after:15),
                    PrayerTimeBuffer(type:"M",before:15,after:15),
                    PrayerTimeBuffer(type:"M",before:15,after:15),
                    PrayerTimeBuffer(type:"M",before:15,after:15),
                    PrayerTimeBuffer(type:"M",before:15,after:15)
            ]
            
            let prayerTimesBufferData = try! PropertyListEncoder().encode(prayerTimesBufferArray)
            
            UserDefaults.standard.set(prayerTimesBufferData, forKey:UserDefaultsConstants.prayerTimesBufferArray)
        }
        
        if  UserDefaults.standard.value(forKey: UserDefaultsConstants.calendarMethod) == nil{
            
            let dect:[String:String]=["methodName":"CalendarMethod.ummAlQura" ,"methdID":"\(6)"]
            UserDefaults.standard.set(dect, forKey:UserDefaultsConstants.calendarMethod)
        }
        
    }
    //    func getUIFonts(){
    //        for name in UIFont.familyNames{
    //            print(name)
    //            for typeFace in UIFont.fontNames(forFamilyName: name){
    //                print(typeFace)
    //            }
    //        }
    //    }
}
