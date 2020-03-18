//
//  LocationVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/18/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class LocationVC: UIViewController {
    //MARK:- IBOUTLET
    @IBOutlet weak var locateMeBtn: UIButton!
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locateMeBtn.setImage(UIImage.location, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          animateBackGround()
      }
    override func viewDidLayoutSubviews() {
         locateMeBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
    }

  //MARK:- Methods
   
   private func animateBackGround(){
       UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
           self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: -1 * self.animatedImage.frame.size.width, dy: 0.0)
           self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: -1 * self.animatedImage2.frame.size.width, dy: 0.0)
       }, completion: nil)
   }
   

}
