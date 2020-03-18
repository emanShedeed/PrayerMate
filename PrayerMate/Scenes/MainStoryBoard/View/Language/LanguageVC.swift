//
//  SettingsVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/17/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import DLRadioButton
class LanguageVC: UIViewController {

    @IBOutlet weak var englishRadioButton: DLRadioButton!
    

    @IBOutlet weak var animatedImage: UIImageView!
     @IBOutlet weak var animatedImage2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        englishRadioButton.setTitle("Arabic", for: .normal)
        englishRadioButton.isSelected = true
        //add gif image
//        let jeremyGif = UIImage.gifImageWithName("funny")
//           let imageView = UIImageView(image: jeremyGif)
//           imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
//           view.addSubview(imageView)
       
    }
    override func viewDidAppear(_ animated: Bool) {
         UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                     self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: -1 * self.animatedImage.frame.size.width, dy: 0.0)
                     self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: -1 * self.animatedImage2.frame.size.width, dy: 0.0)
                 }, completion: nil)
    }
    
    @IBAction func radioButtonPressed(_ sender: Any) {
    }
    @IBAction func arabicBtnPressed(_ sender: Any) {
        AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
        LanguageManager.currentLanguage=AppLanguages.ar.rawValue
        self.reloadRootView()
        present(UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController, animated: true, completion: nil)
    }
    
   private func reloadRootView() {
       if let appDelegate = UIApplication.shared.delegate {
        appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
       }
   }


}
