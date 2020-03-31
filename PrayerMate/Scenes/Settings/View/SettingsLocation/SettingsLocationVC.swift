//
//  SettingsLocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/31/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import CoreLocation
class SettingsLocationVC: UIViewController {
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var addressLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        switchLocation.isOn = detectlocationServicesEnabled()
    }
    

   @IBAction func closeViewBtnPressed(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
      }
    
    @IBAction func switchBtnPressed(_ sender: UISwitch) {
      
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
