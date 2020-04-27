//
//  BaseVC.swift
//  Ataba
//
//  Created by eman shedeed on 8/6/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        styleNavBar()
        TransparentNavBar()
    }
    
    func TransparentNavBar(){ self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func styleNavBar(){
     //   self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.titleTextAttributes =
     [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.white]
    UINavigationBar.appearance().tintColor = UIColor.white
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
