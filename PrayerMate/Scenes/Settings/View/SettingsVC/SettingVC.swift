//
//  SettingVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/29/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    @IBAction func backButtinPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
