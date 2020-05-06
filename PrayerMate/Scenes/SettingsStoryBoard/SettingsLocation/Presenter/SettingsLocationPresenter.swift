//
//  SettingsLocationVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/6/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import CoreLocation
class SettingsLocationPresenter{
    
    private weak var view : LocationViewControllerProtocol?
       init(view:LocationViewControllerProtocol) {
           self.view=view
       }
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
        func getAddressFromLocation(lat:Double,long:Double){
            let geoCoder = CLGeocoder()
            var addressTitle = ""
            var completeAddressTitle = ""
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude:long), completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark?
                placeMark = placemarks?[0]
                
                // Complete address as PostalAddress
                // print(placeMark.postalAddress as Any)  //  Import Contacts
                
                // Location name
                
                if let locationName = placeMark?.name  {
                    print(locationName)
                }
                
                // Street address
                if let street = placeMark?.thoroughfare {
                    print(street)
                }
                
                // Country
                if let country = placeMark?.country {
                    print(country)
                }
                var title=""
                // street
                if let thoroughfare = placeMark?.thoroughfare {
                    title +=  thoroughfare + " , "
                    
                }
                // city
    //                  if let city=placeMark?.locality{
                if let city=placeMark?.administrativeArea{
                    title += city + " , "
                    addressTitle = city
                }
                
                if let country = placeMark?.country{
                    title +=  country
                    //                self.addressTitle += " \(country)"
                }
//                self.addressLbl.text=title
                
                completeAddressTitle = title
                if(completeAddressTitle != ""){
                    UserDefaults.standard.set(completeAddressTitle, forKey: UserDefaultsConstants.completeAddressTitle)
                }
                self.view?.getLocationSucess(title: addressTitle, CompleteAddressTitle: completeAddressTitle)
            })
        }

}
