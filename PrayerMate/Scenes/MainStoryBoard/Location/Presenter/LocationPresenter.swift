//
//  LocationPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 5/5/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import CoreLocation
protocol  LocationViewControllerProtocol :class{
    func getLocationSucess(title:String,CompleteAddressTitle:String)
    
}
final class LocationPresenter{
    private weak var view : LocationViewControllerProtocol?
     init(view:LocationViewControllerProtocol) {
         self.view=view
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
            if let city=placeMark?.administrativeArea {
                title += city + " , "
                addressTitle = city
            }
            
            if let country = placeMark?.country{
                title +=  country
                //                self.addressTitle += " \(country)"
            }
            if addressTitle == "" {
                addressTitle = title.components(separatedBy: " ").first ?? title
            }
//            self.addressTxt.text=title
            completeAddressTitle = title
            self.view?.getLocationSucess(title: addressTitle, CompleteAddressTitle: completeAddressTitle)
        })
        
    }
}
