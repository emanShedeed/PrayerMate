//
//  SettingsLocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/31/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import CoreLocation
protocol SettingsLocationVCView:class {
    func didSelectMethod()
}
class SettingsLocationVC: UIViewController {
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var addressLbl: UILabel!
    
    //MARK:- Variables
    var userLocation:CLLocation?
    let locationManager=CLLocationManager()
    var addressTitle :String = ""
    var completeAddressTitle : String = ""
    var isLocatedAutomatically = false
    weak var toSettingelegate : SettingsLocationVCView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        isLocatedAutomatically=UserDefaults.standard.value(forKey: "isLocatedAutomatically") as? Bool ?? false
        //user aloow acess and use the return address and not use LocateMeBtn
        switchLocation.isOn = detectlocationServicesEnabled() && isLocatedAutomatically
        self.addressLbl.text = UserDefaults.standard.value(forKey: "completeAddressTitle") as? String ?? ""
    }
    
    
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        if(addressTitle != ""){
        UserDefaults.standard.set(addressTitle, forKey: "addressTitle")
        toSettingelegate?.didSelectMethod()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchBtnPressed(_ sender: UISwitch) {
        if(sender.isOn){
            if(detectlocationServicesEnabled()){
                setupLocationManager()
            }else{
                //redirect to settings
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                       UIApplication.shared.open(settingsUrl)
                if(!detectlocationServicesEnabled()){
                    sender.isOn = false
                }
            }
        }else{
            //addressLbl.text = ""
       
        }
        
    }
    @IBAction func changeLocationBtnPressed(_ sender: Any) {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MapNavVC") as! MapNavVC
        let mapVC = viewController.viewControllers[0] as? MapVC
        mapVC?.delegate=self
        self.show(viewController, sender: self)
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
}
extension SettingsLocationVC:CLLocationManagerDelegate{
    func setupLocationManager(){
        //TODO:Set up the location manager here.
        self.locationManager.startUpdatingLocation()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[locations.count-1]
        
        if let l=userLocation
        {
            if(l.horizontalAccuracy>0)
            {
                locationManager.stopUpdatingLocation()
                locationManager.delegate=nil
                //save user location in user defaults
                let lat = l.coordinate.latitude
                let lon = l.coordinate.longitude
                let dect:[String:Double]=["lat":lat,"long":lon]
                UserDefaults.standard.set(dect, forKey: "userLocation")
                
                UserDefaults.standard.set(true, forKey: "isLocatedAutomatically")
                getAddressFromLocation(lat:l.coordinate.latitude,long:l.coordinate.longitude)
            }
        }
    }
    func getAddressFromLocation(lat:Double,long:Double){
        let geoCoder = CLGeocoder()
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
            if let city=placeMark?.locality{
                title += city + " , "
                self.addressTitle = city
            }
            
            if let country = placeMark?.country{
                title +=  country
                //                self.addressTitle += " \(country)"
            }
            self.addressLbl.text=title
            
            self.completeAddressTitle = title
            if(self.completeAddressTitle != ""){
             UserDefaults.standard.set(self.completeAddressTitle, forKey: "completeAddressTitle")
            }
        })
    }
}
extension SettingsLocationVC:maplLocationView{
    func locationIsSeleted(at lat: Double, lng: Double, selectedPlace: String,cityName:String) {
        //          latitude=lat
        //          longitude=lng
        if(selectedPlace != ""){
            let dect:[String:Double]=["lat":lat,"long":lng]
            UserDefaults.standard.set(dect, forKey: "userLocation")
            UserDefaults.standard.set(false, forKey: "isLocatedAutomatically")
            switchLocation.isOn = false
        }
        addressLbl.text=selectedPlace
        if(addressLbl.text != ""){
        UserDefaults.standard.set(addressLbl.text, forKey: "completeAddressTitle")
        }
        
        completeAddressTitle = selectedPlace
        addressTitle=cityName
        
    }
    
}
