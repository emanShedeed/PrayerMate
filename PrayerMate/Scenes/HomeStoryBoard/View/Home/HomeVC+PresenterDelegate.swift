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
        
      
        prayerTimesArray=[(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false)]
        DispatchQueue.main.async {
            self.calendarDateTitleLbl.text = self.presenter.calendarDateTitle
            self.prayerTimestableView.reloadData()
        }

        var nextPrayerIndex = 0
        var accurateString :String = ""
        for  i in 0..<presenter.todayParyerTimes.count {
            accurateString = presenter.todayParyerTimes[i].count == 7 ? "0" + presenter.todayParyerTimes[i] : presenter.todayParyerTimes[i]
            accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
            accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
            accurateString = accurateString.replacingOccurrences(of: " ", with: ":00 ")
            let dateAsString = countDownTimerFormatter.string(from: Date())
            let dateDiff = Helper.findDateDiff(time1Str: dateAsString, time2Str: accurateString)
            if(!dateDiff.contains("-") ){
                nextPrayerIndex = i
                break
            }
            
        }

        
      var tempString = accurateString.replacingOccurrences(of: " PM", with: "")
        tempString = tempString.replacingOccurrences(of: " AM", with: "")
        var dateComponent = tempString.split(separator: ":")
        
        if(accurateString.contains("PM")){
            let hours = Int(dateComponent[0]) ?? 0
            if (hours < 12) {
                dateComponent[0] = "\(hours + 12)"
            }
        }
        nextPrayerDateDate = {
            let future = DateComponents(
                year: calendar.component(.year, from: Date()),
                month: calendar.component(.month, from: Date()),
                day: calendar.component(.day, from: Date()),
                hour: Int(dateComponent[0]),
                minute: Int(dateComponent[1]),
                second: Int(dateComponent[2])
            )
            return Calendar.current.date(from: future)!
        }()

        DispatchQueue.main.async {
  self.selectedPrayerTimeName.text=self.presenter.prayerTimesNames[nextPrayerIndex].localized
            
            self.runCountdown()
        }
        
    }
}
