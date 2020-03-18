//
//  SettingsVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/17/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func arabicBtnPressed(_ sender: Any) {
        AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
        self.reloadRootView()
        present(UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController, animated: true, completion: nil)
    }
    
   private func reloadRootView() {
       if let appDelegate = UIApplication.shared.delegate {
        appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
       }
   }


}
