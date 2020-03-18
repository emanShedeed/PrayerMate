//
//  SettingsVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/17/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import DLRadioButton
final class LanguageVC: UIViewController {
    //MARK:- IBOUTLET
    @IBOutlet weak var englishRadioButton: DLRadioButton!
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        englishRadioButton.isSelected = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        animateBackGround()
    }
    
    //MARK:- IBAction
    

//    @IBAction func radioButtonPressed(_ sender: DLRadioButton) {
//        let tag = sender.tag
//        switch tag {
//        case 2 :
//            AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
//            LanguageManager.currentLanguage=AppLanguages.ar.rawValue
//        default:
//            AppSetting.shared.setCurrentLanguage(language: AppLanguages.en)
//            LanguageManager.currentLanguage=AppLanguages.en.rawValue
//        }
//        
//    }
//    @IBAction func arabicBtnPressed(_ sender: Any) {
//        //        AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
//        //        LanguageManager.currentLanguage=AppLanguages.ar.rawValue
//        //        self.reloadRootView()
//        //        present(UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController, animated: true, completion: nil)
//    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        self.reloadRootView()
        present(UIStoryboard.main.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC, animated: true, completion: nil)
    }
    
    //MARK:- Methods
    
    private func animateBackGround(){
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: -1 * self.animatedImage.frame.size.width, dy: 0.0)
            self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: -1 * self.animatedImage2.frame.size.width, dy: 0.0)
        }, completion: nil)
    }
    
    private func reloadRootView() {
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
        }
    }
    
    
}
