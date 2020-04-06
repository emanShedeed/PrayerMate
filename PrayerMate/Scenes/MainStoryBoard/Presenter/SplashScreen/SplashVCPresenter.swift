//
//  SplashVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/6/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
final class SplashVCPresenter{
    /**
       Call this function for setup User Defaults for first use of the App
       - Parameters:
         
       ### Usage Example: ###
       ````
       SplashVCPresenter().setupUserDefaults()
       
       ````
       */
    func setupUserDefaults(){
        if  UserDefaults.standard.value(forKey: "automaticAdjustBufferToggle") == nil{
            UserDefaults.standard.set(false, forKey: "automaticAdjustBufferToggle")
        }
        
        
        
        if  UserDefaults.standard.value(forKey: "prayerTimesBufferArray") == nil{
            
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
            
            UserDefaults.standard.set(prayerTimesBufferData, forKey: "prayerTimesBufferArray")
        }
        
        if  UserDefaults.standard.value(forKey: "calendarMethod") == nil{
            
            let dect:[String:String]=["methodName":"CalendarMethod.ummAlQura" ,"methdID":"\(6)"]
            UserDefaults.standard.set(dect, forKey: "calendarMethod")
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
