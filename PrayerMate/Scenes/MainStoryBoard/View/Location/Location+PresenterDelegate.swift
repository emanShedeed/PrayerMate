//
//  Location+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 5/5/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
extension LocationViewController:LocationViewControllerProtocol{
    func getLocationSucess(title: String, CompleteAddressTitle: String) {
        addressTitle = title
        completeAddressTitle = CompleteAddressTitle
        self.addressTxt.text=completeAddressTitle
    }
    
    
}
