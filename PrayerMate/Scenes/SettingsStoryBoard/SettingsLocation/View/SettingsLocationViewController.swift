//
//  SettingsLocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/31/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import CoreLocation
/// This is a class created for handling the user Location
class SettingsLocationViewController: UIViewController {
    
    //MARK:- IBOUTLET
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
    weak var toSettingelegate : UpdateSettingsProtcol?
    var presenter : SettingsLocationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter = SettingsLocationPresenter(view: self)
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        isLocatedAutomatically=UserDefaults.standard.value(forKey: "isLocatedAutomatically") as? Bool ?? false
        //user aloow acess and use the return address and not use LocateMeBtn
        switchLocation.isOn = presenter.detectlocationServicesEnabled() && isLocatedAutomatically
        self.addressLbl.text = UserDefaults.standard.value(forKey: UserDefaultsConstants.completeAddressTitle) as? String ?? ""
    }
    
    //MARK:- IBActions
    
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        if(addressTitle != ""){
            UserDefaults.standard.set(addressTitle, forKey:UserDefaultsConstants.addressTitle)
        toSettingelegate?.didUpdateSettings()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchBtnPressed(_ sender: UISwitch) {
        if(sender.isOn){
            if(presenter.detectlocationServicesEnabled()){
                setupLocationManager()
            }else{
                //redirect to settings
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                       UIApplication.shared.open(settingsUrl)
                if(!presenter.detectlocationServicesEnabled()){
                    sender.isOn = false
                }
            }
        }else{
            //addressLbl.text = ""
       
        }
        
    }
    @IBAction func changeLocationBtnPressed(_ sender: Any) {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
       // let mapVC = viewController.viewControllers[0] as? MapViewController
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.barTintColor = UIColor.appColor
        nav.modalPresentationStyle = .fullScreen
        viewController.delegate=self
        self.show(nav, sender: self)
    }
    
   
}
/// This is a class created for handling CLLocationManager delegate  functions
extension SettingsLocationViewController:CLLocationManagerDelegate{
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
        
        if let location=userLocation
        {
            if(location.horizontalAccuracy>0)
            {
                locationManager.stopUpdatingLocation()
                locationManager.delegate=nil
                //save user location in user defaults
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                let dect:[String:Double]=["lat":lat,"long":lon]
                UserDefaults.standard.set(dect, forKey: UserDefaultsConstants.userLocation)
                
                UserDefaults.standard.set(true, forKey: UserDefaultsConstants.isLocatedAutomatically)
                presenter.getAddressFromLocation(lat:location.coordinate.latitude,long:location.coordinate.longitude)
                 
            }
        }
    }

}
/// This is a class created for handling maplLocation to display Location Address
extension SettingsLocationViewController:maplLocationProtcol{
    func locationIsSeleted(at lat: Double, lng: Double, selectedPlace: String,cityName:String) {
        if(selectedPlace != ""){
            let dect:[String:Double]=["lat":lat,"long":lng]
            UserDefaults.standard.set(dect, forKey:UserDefaultsConstants.userLocation)
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.isLocatedAutomatically)
            switchLocation.isOn = false
        }
        addressLbl.text=selectedPlace
        if(addressLbl.text != ""){
            UserDefaults.standard.set(addressLbl.text, forKey: UserDefaultsConstants.completeAddressTitle)
        }
        
        completeAddressTitle = selectedPlace
        addressTitle=cityName
        
    }
    
}
