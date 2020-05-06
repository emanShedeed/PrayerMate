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
final class LocationViewController: UIViewController {
    
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
    var presenter:LocationPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
        presenter=LocationPresenter(view: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        animateBackGround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationcomeFromBackGround),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    @objc func applicationcomeFromBackGround(){
        animateBackGround()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locateMeBtn.applyGradient(with:  [UIColor.locatemeBtnG1!, UIColor.locatemeBtnG2!], gradient: .horizontal)
        animateBackGround()
    }
    override func viewDidLayoutSubviews() {
//
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        if (isLocationSet && addressTitle != "" ){
            UserDefaults.standard.set(dect, forKey: UserDefaultsConstants.userLocation)
            let viewController = UIStoryboard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            
            UserDefaults.standard.set(addressTitle, forKey: UserDefaultsConstants.addressTitle)
            
            UserDefaults.standard.set(completeAddressTitle, forKey: UserDefaultsConstants.completeAddressTitle)
            
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
            let dVC=((segue.destination) as! UINavigationController).viewControllers[0] as!MapViewController
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
extension LocationViewController:CLLocationManagerDelegate{
    
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
        if let location=userLocation
        {
            if(location.horizontalAccuracy>0)
            {
                locationManager.stopUpdatingLocation()
                locationManager.delegate=nil
                //save user location in user defaults
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                 dect=["lat":lat,"long":lon]
              //  UserDefaults.standard.set(dect, forKey: "userLocation")
                isLocationSet = true
                UserDefaults.standard.set(true, forKey: UserDefaultsConstants.isLocatedAutomatically)
                presenter.getAddressFromLocation(lat:location.coordinate.latitude,long:location.coordinate.longitude)
                 
            }
        }
        }else{
            Helper.showAlert(title: "", message: "internetFailMessage".localized, VC: self)
        }
    }
    

}
//MARK:- Location ViewController Confirm to maplLocationProtcol to Display Addrees

extension LocationViewController:maplLocationProtcol{
    
    func locationIsSeleted(at lat: Double, lng: Double, selectedPlace: String,cityName:String) {
        //          latitude=lat
        //          longitude=lng
        if(selectedPlace != ""){
           dect=["lat":lat,"long":lng]
          //  UserDefaults.standard.set(dect, forKey: "userLocation")
            isLocationSet = true
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.isLocatedAutomatically)
        
        addressTxt.text=selectedPlace
        completeAddressTitle = selectedPlace
        addressTitle = cityName != "" ? cityName :  completeAddressTitle.components(separatedBy: " ").first ?? completeAddressTitle
        }
    }
    
}
