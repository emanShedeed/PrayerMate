//
//  HomeVC+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
extension HomeVC:HomeView{
    func showError(error: String) {
        Helper.showAlert(title: "", message: error, VC: self)
    }
    
    func fetchDataSucess() {
        numberOfSelectedPrayerTimes = 0
        prayerTimesArray=[(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false)]
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.calendarDateTitleLbl.text = self.presenter.calendarDateTitle
            self.prayerTimestableView.reloadData()
            self.getNextPrayerTime()
        }
     
    }
}
extension HomeVC:settingsVCView{
    func APIParameterChanged() {
        requestPrayerTimesAPI()
    }
    
    
}
