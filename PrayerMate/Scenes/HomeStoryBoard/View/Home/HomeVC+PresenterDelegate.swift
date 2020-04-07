//
//  HomeVC+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
/// This is a class created for conform to HomeView to display prayer times after fetching from API
extension HomeVC:HomeView{
    /**
     protcol delegate function called when there was an error fetching  data
     - Parameters:
     */
    func showError(error: String) {
        DispatchQueue.main.async {
            Helper.showAlert(title: "", message: error, VC: self)
            self.activityIndicator.stopAnimating()
        }
    }
    /**
     protcol delegate function called when success to fetch data
     - Parameters:
     */
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
/// This is a class created for conform to settingsVCView to recall the API if there is any change at settings Parameters
extension HomeVC:settingsVCView{
    func APIParameterChanged() {
        requestPrayerTimesAPI()
    }
    
}
