//
//  SettingsLocationVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/6/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import CoreLocation
class SettingsLocationPresenter{
    func detectlocationServicesEnabled() -> Bool{
           var haveAccess = false
           if CLLocationManager.locationServicesEnabled() {
               switch CLLocationManager.authorizationStatus() {
               case .notDetermined, .restricted, .denied:
                   print("No access")
                   haveAccess = false
               case .authorizedAlways, .authorizedWhenInUse:
                   print("Access")
                   haveAccess = true
               @unknown default:
                   // return false
                   break
               }
           } else {
               print("Location services are not enabled")
               haveAccess = false
           }
           return haveAccess
       }
}
