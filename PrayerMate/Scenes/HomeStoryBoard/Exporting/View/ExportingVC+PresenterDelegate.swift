//
//  ExportingVC+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/4/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//


import Foundation
/// This is a class created for conform to HomeView to display prayer times after fetching from API
extension ExportingViewController:ExportingViewControllerProtocol{
  
  
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

    func showIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
    }
      
    func imoprtToCalendarsSuccess() {
        Helper.showToast(message: "Home.exportedSuccessfullyToasterMessage".localized)
        activityIndicator.stopAnimating()
     
      }
      
}
extension ExportingViewController:ExportingPopUpViewControllerProtocol{
    
    func importToCalendarsOkBtnPressed(withperiodSelected: Int) {
        let formatter=DateFormatter()
        formatter.locale=NSLocale(localeIdentifier: "en") as Locale
       formatter.dateFormat = "yyyy-M-d"
        
        let secondDate = Calendar.current.date(byAdding: .day, value: withperiodSelected - 1 , to: Date())
//        self.activityIndicator.startAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.presenter.importPrayerTimesToSelectedCalendars(importStartDateAsString: formatter.string(from: Date()), importEndDateAsString: formatter.string(from:secondDate ?? Date()))
                    UserDefaults.standard.set(secondDate, forKey:UserDefaultsConstants.lastImportDate)
//                                 let _ = PrayerTimeLocalNotification()
                }
                prayerTimesArray = [(Bool,Bool)]( repeating: (false,false), count: 6 )
                automaticSelectPrayerTimeswitch.isOn = false
                numberOfSelectedPrayerTimes = 0
                self.prayerTimestableView.reloadData()
        let renewalNotificationDate = Calendar.current.date(byAdding: .day, value: -1 , to: secondDate ?? Date())
        let _ = ExportPrayerTimeToCalendarNotification(notification: Notification(title: "", description: "notificationBody".localized, time: "7:55 am", date: renewalNotificationDate))//Date()
    }
    

}
