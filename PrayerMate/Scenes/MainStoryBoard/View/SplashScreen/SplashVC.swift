//
//  LaunchVC.swift
//  Ataba
//
//  Created by eman shedeed on 9/7/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    lazy private var activityIndicator : SYActivityIndicatorView = {
        let image = UIImage.loading
        return SYActivityIndicatorView(image: UIImage.loading,title: "loader.messageTitle".localized)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        print(UIFont.systemFont(ofSize: 15).fontName)
        //  getUIFonts()

        ///
//        UserDefaults.standard.set(nil, forKey:"calendarMethod" )
         if  UserDefaults.standard.value(forKey: "automaticAdjustBufferToggle") == nil{
             UserDefaults.standard.set(false, forKey: "automaticAdjustBufferToggle")
        }
        let prayerTimesBufferArray =
            [
            PrayerTimeBuffer(type:"M",before:15,after:15),
            PrayerTimeBuffer(type:"M",before:15,after:15),
            PrayerTimeBuffer(type:"M",before:15,after:15),
            PrayerTimeBuffer(type:"M",before:15,after:15),
            PrayerTimeBuffer(type:"M",before:15,after:15),
            PrayerTimeBuffer(type:"M",before:15,after:15)
        ]
        let prayerTimesBufferData = try! PropertyListEncoder().encode(prayerTimesBufferArray)
        if  UserDefaults.standard.value(forKey: "prayerTimesBufferArray") == nil{
                    UserDefaults.standard.set(prayerTimesBufferData, forKey: "prayerTimesBufferArray")
               }
        if  UserDefaults.standard.value(forKey: "calendarMethod") == nil{
        let dect:[String:String]=["methodName":"CalendarMethod.ummAlQura" ,"methdID":"\(6)"]
            UserDefaults.standard.set(dect, forKey: "calendarMethod")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.loadingView.center
        activityIndicator.startAnimating()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            UserDefaults.standard.set(nil, forKey:"appLanguage" )
//            UserDefaults.standard.set(false, forKey:"userLocation" )
            if AppSetting.shared.getCurrentLanguage() != nil{
                 if let _ = UserDefaults.standard.value(forKey: "userLocation") as? [String:Double]{
                    let viewController = UIStoryboard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.present(viewController, animated: true, completion:nil)
                }
                else{
                    let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                    self.present(viewController, animated: true, completion:nil)
                
                }
                
            }else{
                //                self.present(AppLanguageViewController.instantiate(fromAppStoryboard: .main), animated: false, completion: nil)
                self.performSegue(withIdentifier: "goToLanguageVC", sender: self)
            }
        }
        
        
    }
    
    //    func getUIFonts(){
    //        for name in UIFont.familyNames{
    //            print(name)
    //            for typeFace in UIFont.fontNames(forFamilyName: name){
    //                print(typeFace)
    //            }
    //        }
    //    }
}
