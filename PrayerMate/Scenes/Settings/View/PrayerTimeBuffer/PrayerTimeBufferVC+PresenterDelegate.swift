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
    
    func setBufferSucess() {
        if(presenter.getToggleValue()){
            automaticAdjustBufferLbl.text = presenter.getbufferText(index: 0)
        }else{
            automaticAdjustBufferLbl.text = ""
        }
        PrayerTimeBufferTableView.reloadData()
    }
    
    
}
