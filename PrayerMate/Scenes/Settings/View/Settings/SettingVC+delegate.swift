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
/// This is a class created to conform to UpdateSettingsView to reload settings view if any change
extension SettingVC:UpdateSettingsView{
    /**
           protcol delegate function called when any parameter at settings change
           - Parameters:
           */
    func didUpdateSettings() {
        isApiParameterUpdated = true
        SettingsArray=presenter.setDefaultValues()
        settingsTableView.reloadData()
    }
    
    
}
extension SettingVC:UpdateCalendarNameSettingsView{
    func didUpdateCalendarName() {
    SettingsArray=presenter.setDefaultValues()
    settingsTableView.reloadData()
    }
    
    
}
