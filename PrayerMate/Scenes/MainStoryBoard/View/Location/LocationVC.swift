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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
         locateMeBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
    }

  

}
