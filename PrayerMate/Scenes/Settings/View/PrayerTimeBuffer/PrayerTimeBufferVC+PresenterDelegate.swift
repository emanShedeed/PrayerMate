//
//  PrayerTimeBufferVC+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/2/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
extension PrayerTimeBufferVC:PrayerTimeBufferView{
    func showError(error: String) {
        
    }
    
    func setBufferSucess(forAll:Bool) {
        if(presenter.getToggleValue() && forAll){
            automaticAdjustBufferSwitch.isOn = true
            automaticAdjustBufferLbl.text = presenter.getbufferText(index: 0)
        }else{
            automaticAdjustBufferSwitch.isOn = false
            automaticAdjustBufferLbl.text = ""
        }
        PrayerTimeBufferTableView.reloadData()
    }
    
    
}
extension PrayerTimeBufferVC:UpdatePrayerTimesBufferView{
    func didUpdateBuffer(forAll:Bool) {
        setBufferSucess(forAll: forAll)
    }
    
   
    
    
}
