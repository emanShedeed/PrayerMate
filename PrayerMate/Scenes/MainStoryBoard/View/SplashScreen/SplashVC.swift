//
//  LaunchVC.swift
//  Ataba
//
//  Created by eman shedeed on 9/7/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Helper.getUserDetails()
        Thread.sleep(forTimeInterval: 1.5)
         DispatchQueue.main.async(){
        if user.count != 0 {
                self.performSegue(withIdentifier: "goToMovesHome", sender: self)
            }
        else{
                self.performSegue(withIdentifier: "goToWeclcomeVC", sender: self)
        }
        }
          navigationController?.setNavigationBarHidden(true, animated: animated)
         
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
