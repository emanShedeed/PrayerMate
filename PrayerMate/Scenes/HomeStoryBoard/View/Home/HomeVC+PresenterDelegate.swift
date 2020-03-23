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
        
    }
    
    func fetchDataSucess() {
   prayerTimesArray=[(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false)]
        DispatchQueue.main.async {
            self.prayerTimestableView.reloadData()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let myString = formatter.string(from: Date())
               // read input date string as NSDate instance
        let currentDate = formatter.date(from: myString)
        var prayerDate : Date
        var nextPrayerIndex = 0
        var accurateString :String
        for  i in 0..<presenter.todayParyerTimes.count {
             accurateString = presenter.todayParyerTimes[i].count == 7 ? "0" + presenter.todayParyerTimes[i] : presenter.todayParyerTimes[i]
           accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
            accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
            if let prayerDate = formatter.date(from: accurateString){
            let result = currentDate?.compare(prayerDate)
            if(result == .orderedAscending){
                nextPrayerIndex = i
                break
            }
        }
        }
        DispatchQueue.main.async {
            self.selectedPrayerTimeName.text=self.presenter.prayerTimesNames[nextPrayerIndex].localized
        }

       
    }
    
    
}
