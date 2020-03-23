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
        formatter.dateFormat = "hh:mm:ss a"
//        let date = Date()
        let myString = formatter.string(from: Date())
        // read input date string as NSDate instance
        //        let currentDate = formatter.date(from: myString)
        //        var prayerDate : Date
        var nextPrayerIndex = 0
        var accurateString :String = ""
        for  i in 0..<presenter.todayParyerTimes.count {
            accurateString = presenter.todayParyerTimes[i].count == 7 ? "0" + presenter.todayParyerTimes[i] : presenter.todayParyerTimes[i]
            accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
            accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
            accurateString = accurateString.replacingOccurrences(of: " ", with: ":00 ")
            //            if let prayerDate = formatter.date(from: accurateString){
            //            let result = currentDate?.compare(prayerDate)
            let dateDiff = Helper.findDateDiff(time1Str: myString, time2Str: accurateString)
            if(!dateDiff.contains("-") ){
                nextPrayerIndex = i
                break
            }
        }
        let dateDiff = Helper.findDateDiff(time1Str: myString, time2Str: accurateString)
        
        print(dateDiff)
        DispatchQueue.main.async {
            self.selectedPrayerTimeName.text=self.presenter.prayerTimesNames[nextPrayerIndex].localized
            self.remainingTimeLbl.text = dateDiff
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm:ss"
            
            if let currentDate = timeFormatter.date(from: dateDiff){
                print(self.countdown)
                self.countdown = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate, to: self.futureDate)
              self.runCountdown()
                
            }
        }
    }
}
