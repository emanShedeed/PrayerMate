//
//  LocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/18/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import CoreLocation
class LocationVC: UIViewController {
    //MARK:- IBOUTLET
    @IBOutlet weak var locateMeBtn: UIButton!
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!
    
    @IBOutlet weak var addressLbl: RoundedTextField!
    //MARK:- Variables
    var userLocation:CLLocation?
    let locationManager=CLLocationManager()
    var addressTitle :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBackGround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    @objc func applicationDidBecomeActive(){
        animateBackGround()
    }
    override func viewDidLayoutSubviews() {
        locateMeBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        if let _ = UserDefaults.standard.value(forKey: "userLocation") as? [String:Double]{
            let viewController = UIStoryboard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            viewController.addressTitle=addressTitle
            self.present(viewController, animated: true, completion:nil)
        }else{
            Helper.showAlert(title: "", message: "Location.alertMessage".localized, VC: self)
        }
     UserDefaults.standard.set(addressTitle, forKey: "addressTitle")
    }
    
    @IBAction func locateMeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToMapVC", sender: self)
    }
    
    //MARK:- Methods
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier=="goToMapVC"){
//            let dVC=((segue.destination) as! UINavigationController).viewControllers[0] as!MapVC
//            dVC.delegate=self
//        }
//
//    }
    private func animateBackGround(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: 1 * self.animatedImage.frame.size.width, dy: 0.0)
                self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: 1 * self.animatedImage2.frame.size.width, dy: 0.0)
            }, completion: nil)
        }
    }
    
    
}
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
        })
    }
}
extension LocationVC:maplLocationView{
    func locationIsSeleted(at lat: Double, lng: Double, selectedPlace: String,cityName:String) {
        //          latitude=lat
        //          longitude=lng
        if(selectedPlace != ""){
            let dect:[String:Double]=["lat":lat,"long":lng]
            UserDefaults.standard.set(dect, forKey: "userLocation")
        }
        addressLbl.text=selectedPlace
        addressTitle=cityName
       
    }
    
}
