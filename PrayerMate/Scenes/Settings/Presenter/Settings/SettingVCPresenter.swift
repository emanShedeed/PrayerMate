//
//  SettingVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/6/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
class SettingVCPresenter{
    /**
               Call this function for read default Values from User Defaults
              
                 
               ### Usage Example: ###
               ````
               setDefaultValues()
               
               ````
             - Parameters:
           
               */
    func setDefaultValues()->[(image: UIImage, name: String , value:String)]{
        let method = UserDefaults.standard.value(forKey: "calendarMethod") as? [String:String]
        let calendars = UserDefaults.standard.value(forKey: "choosenCalendars") as? [Int]
        var calendarName = ""
        if(calendars?.count ?? 0 > 0){
            if (calendars?.first == 0){
                calendarName =  "ImportToCalendarVC.appleLbl".localized
            } else if calendars?.first == 1{
                calendarName = "ImportToCalendarVC.googleLbl".localized
            } else if calendars?.first == 2 {
                calendarName = "ImportToCalendarVC.MSLbl".localized
            }
        }
        let methodName = method?["methodName"]?.localized
        let addressTitle = UserDefaults.standard.value(forKey: "addressTitle") as? String ?? ""
       let SettingsArray = [(image:UIImage.settingsLocation!,name:"Settings.location".localized,value:addressTitle),(image:UIImage.language!,name:"Settings.language".localized,value:"language".localized),(image:UIImage.clock!,name:"Settings.prayerTimeBuffer".localized,value:""),(image:UIImage.calendar!,name:"Settings.importToCalendar".localized,value:calendarName),(image:UIImage.method!,name:"Settings.calendarMethod".localized,value:methodName ?? ""),(image:UIImage.hourclock!,name:"Settings.about".localized,value:""),(image:UIImage.faq!,name:"Settings.faqs".localized,value:""),(image:UIImage.invite!,name:"Settings.inviteFriends".localized,value:"")]
         return SettingsArray
    }
    
    /**
        Call this function to reload App After change Language
       
          
        ### Usage Example: ###
        ````
        reloadRootView()
        
        ````
      - Parameters:
    
        */
     func reloadRootView() {
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
        }
    }
    
       //MARK:- Methods
       
       /**
                     Call this function to create Language Action Sheet
                    
                       
                     ### Usage Example: ###
                     ````
                     createActionSheet()
                     
                     ````
                   - Parameters:
                 
                     */
       func createActionSheet()-> UIAlertController{
           let actionSheetController=UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
           // create an action
           let englishAction = UIAlertAction(title: "Language.en".localized, style: .default) { action -> Void in
               if(AppSetting.shared.getCurrentLanguage() == AppLanguages.ar){
                   AppSetting.shared.setCurrentLanguage(language: AppLanguages.en)
                   LanguageManager.currentLanguage=AppLanguages.en.rawValue
                   self.reloadRootView()
               }
           }
           englishAction.setValue(UIColor.black, forKey: "titleTextColor")
           // create an action
           let arabicAction = UIAlertAction(title: "Language.ar".localized, style: .default) { action -> Void in
               if(AppSetting.shared.getCurrentLanguage() == AppLanguages.en){
                   AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
                   LanguageManager.currentLanguage=AppLanguages.ar.rawValue
                       self.reloadRootView()
               }
           }
           arabicAction.setValue(UIColor.black, forKey: "titleTextColor")
           
           
           // create an action
           let doneAction = UIAlertAction(title: "Language.done".localized, style: .cancel) { action -> Void in }
           doneAction.setValue(UIColor(rgb: 0xEA961E), forKey: "titleTextColor")
           
           // add actions
           actionSheetController.addAction(englishAction)
           actionSheetController.addAction(arabicAction)
           actionSheetController.addAction(doneAction)
        return actionSheetController
    }
}
