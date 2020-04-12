//
//  LocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/18/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import CoreLocation
/// This is a class created for handling the user Location for the first use
final class LocationVC: UIViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet weak var locateMeBtn: UIButton!
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!
    @IBOutlet weak var addressTxt: RoundedTextField!
    @IBOutlet weak var animatedImageLeading: NSLayoutConstraint!
    @IBOutlet weak var animatedImageTrailing: NSLayoutConstraint!
    
    //MARK:- Variables
    
    var userLocation:CLLocation?
    let locationManager=CLLocationManager()
    var addressTitle :String = ""
    var completeAddressTitle : String = ""
    var isLocationSet = false
    var dect:[String:Double]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        animateBackGround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    @objc func applicationDidBecomeActive(){
        animateBackGround()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locateMeBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
        animateBackGround()
    }
    override func viewDidLayoutSubviews() {
//
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        if (isLocationSet && addressTitle != "" ){
            UserDefaults.standard.set(dect, forKey: "userLocation")
            let viewController = UIStoryboard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            
            UserDefaults.standard.set(addressTitle, forKey: "addressTitle")
            
            UserDefaults.standard.set(completeAddressTitle, forKey: "completeAddressTitle")
            
            self.present(viewController, animated: true, completion:nil)
            
        }else{
            
            Helper.showAlert(title: "", message: "Location.alertMessage".localized, VC: self)
            
        }
    }
    
    @IBAction func locateMeBtnPressed(_ sender: Any) {
        if(Helper.isConnectedToNetwork()){
        performSegue(withIdentifier: "goToMapVC", sender: self)
        }else{
            Helper.showAlert(title: "", message: "internetFailMessage".localized, VC: self)
        }
    }
    
    //MARK:- Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToMapVC"){
            let dVC=((segue.destination) as! UINavigationController).viewControllers[0] as!MapVC
            dVC.delegate=self
        }
        
    }
    private func animateBackGround(){
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
     
            self.animatedImageLeading.constant += self.animatedImage.frame.width
            
            self.animatedImageTrailing.constant += self.animatedImage.frame.width
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    
}
//MARK:- Location Manger Deglegate Functions
extension LocationVC:CLLocationManagerDelegate{
    
    func setupLocationManager(){
        //TODO:Set up the location manager here.
        self.locationManager.startUpdatingLocation()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(Helper.isConnectedToNetwork()){
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
                 dect=["lat":lat,"long":lon]
              //  UserDefaults.standard.set(dect, forKey: "userLocation")
                isLocationSet = true
                UserDefaults.standard.set(true, forKey: "isLocatedAutomatically")
                getAddressFromLocation(lat:l.coordinate.latitude,long:l.coordinate.longitude)
            }
        }
        }else{
            Helper.showAlert(title: "", message: "internetFailMessage".localized, VC: self)
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
            if let city=placeMark?.administrativeArea {
                title += city + " , "
                self.addressTitle = city
            }
            
            if let country = placeMark?.country{
                title +=  country
                //                self.addressTitle += " \(country)"
            }
            if self.addressTitle == "" {
                self.addressTitle = title.components(separatedBy: " ").first ?? title
            }
            self.addressTxt.text=title
            self.completeAddressTitle = title
        })
    }
}
//MARK:- Location ViewController Confirm to maplLocationView to Display Addrees

extension LocationVC:maplLocationView{
    
    func locationIsSeleted(at lat: Double, lng: Double, selectedPlace: String,cityName:String) {
        //          latitude=lat
        //          longitude=lng
        if(selectedPlace != ""){
           dect=["lat":lat,"long":lng]
          //  UserDefaults.standard.set(dect, forKey: "userLocation")
            isLocationSet = true
            UserDefaults.standard.set(false, forKey: "isLocatedAutomatically")
        
        addressTxt.text=selectedPlace
        completeAddressTitle = selectedPlace
        addressTitle = cityName != "" ? cityName :  completeAddressTitle.components(separatedBy: " ").first ?? completeAddressTitle
        }
    }
    
}
