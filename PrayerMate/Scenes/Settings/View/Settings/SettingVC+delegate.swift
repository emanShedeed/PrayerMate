//
//  SettingVC+delegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/31/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
protocol settingsVCView {
    func APIParameterChanged()
}
extension SettingVC:CalendarMethodVCView,SettingsLocationVCView{
    func didSelectMethod() {
        let method = UserDefaults.standard.value(forKey: "calendarMethod") as? [String:String]
        let methodName = method?["methodName"]?.localized
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
         let addressTitle = UserDefaults.standard.value(forKey: "addressTitle") as? String ?? ""
               SettingsArray = [(image:UIImage.settingsLocation!,name:"Settings.location".localized,value:addressTitle),(image:UIImage.language!,name:"Settings.language".localized,value:"language".localized),(image:UIImage.clock!,name:"Settings.prayerTimeBuffer".localized,value:""),(image:UIImage.calendar!,name:"Settings.importToCalendar".localized,value:calendarName),(image:UIImage.method!,name:"Settings.calendarMethod".localized,value:methodName ?? ""),(image:UIImage.hourclock!,name:"Settings.about".localized,value:""),(image:UIImage.faq!,name:"Settings.faqs".localized,value:""),(image:UIImage.invite!,name:"Settings.inviteFriends".localized,value:"")]
        settingsTableView.reloadData()
        
    }
    
    
}
