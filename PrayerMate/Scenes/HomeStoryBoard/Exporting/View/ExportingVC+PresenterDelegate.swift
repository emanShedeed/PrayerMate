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
