//
//  SettingsVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/17/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
/// This is a class created for handling the App Language  for the first use
final class LanguageViewController: UIViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet weak var englishRadioButton: UIButton!
    @IBOutlet weak var arabicRadioButton: UIButton!
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!
    @IBOutlet weak var animatedImageLeading: NSLayoutConstraint!
    @IBOutlet weak var animatedImageTrailing: NSLayoutConstraint!
    
    //MARK:- Variables
    var radioButtonTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        englishRadioButton.isSelected=true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationcomeFromBackGround),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackGround()
    }
    @objc func applicationcomeFromBackGround(){
        animateBackGround()
    }
    
    //MARK:- IBAction
    
    @IBAction func radioButtonPressed(_ sender: UIButton) {
        let tag = sender.tag
        sender.setImage(UIImage.selectedRadio, for: .normal)
        switch tag {
            
        case 2 :
            radioButtonTag = 2
            englishRadioButton.setImage(UIImage.unSelectedRadio, for: .normal)
            
        default:
            radioButtonTag = 1
            arabicRadioButton.setImage(UIImage.unSelectedRadio, for: .normal)
            
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        switch radioButtonTag {
            
        case 2 :
            AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
            LanguageManager.currentLanguage=AppLanguages.ar.rawValue
            
        default:
            AppSetting.shared.setCurrentLanguage(language: AppLanguages.en)
            LanguageManager.currentLanguage=AppLanguages.en.rawValue
            
        }
        
        self.reloadRootView()
    }
    
    //MARK:- Methods
    
    private func animateBackGround(){
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            
           /*  self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: 1 * self.animatedImage.frame.size.width, dy: 0.0)
                       self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: 1 * self.animatedImage2.frame.size.width, dy: 0.0)
            */
            
            self.animatedImageLeading.constant += self.animatedImage.frame.width
            
            self.animatedImageTrailing.constant += self.animatedImage.frame.width
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    private func reloadRootView() {
        
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
            
        }
    }
    
    
}
