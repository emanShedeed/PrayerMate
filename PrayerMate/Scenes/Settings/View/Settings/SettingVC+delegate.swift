//
//  SettingVC+delegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/31/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
extension SettingVC:CalendarMethodVCView{
    func didSelectMethod() {
        let method = UserDefaults.standard.value(forKey: "calendarMethod") as? [String:String]
               let methodName = method?["methodName"]
               SettingsArray = [(image:UIImage.settingsLocation!,name:"Settings.location".localized,value:""),(image:UIImage.language!,name:"Settings.language".localized,value:""),(image:UIImage.clock!,name:"Settings.prayerTimeBuffer".localized,value:""),(image:UIImage.calendar!,name:"Settings.importToCalendar".localized,value:""),(image:UIImage.method!,name:"Settings.calendarMethod".localized,value:methodName ?? ""),(image:UIImage.hourclock!,name:"Settings.about".localized,value:""),(image:UIImage.faq!,name:"Settings.faqs".localized,value:""),(image:UIImage.invite!,name:"Settings.inviteFriends".localized,value:"")]
        settingsTableView.reloadData()
    }
    
    
}
