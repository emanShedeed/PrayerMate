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
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm "
//        let myString = formatter.string(from: Date())
//               // read input date string as NSDate instance
//        let currentDate = formatter.date(from: myString)
//        var min = currentDate?.timeIntervalSince(formatter.date(from: presenter?.todayParyerTimes[0] ?? "") ?? Date())
//        var minIndex = 0
//        print(min)
////        for  i in 1..<presenter.todayParyerTimes.count {
////
////            let currentmin = currentDate?.timeIntervalSince(formatter.date(from: presenter?.todayParyerTimes[i] ?? "") ?? Date())
////            if (currentmin < min) {
////                   min = currentmin;
////                   minIndex = i;
////             }
////        }
//        print(min)
       
    }
    
    
}
