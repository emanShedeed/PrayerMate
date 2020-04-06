//
//  MovesVC.swift
//  Ataba
//
//  Created by eman shedeed on 12/11/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    //MARK:- IBOUTLET
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          roundedView.roundCorners([.topLeft,.topRight], radius: 20)
    }
    
  //MARK:- IBActions
    
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
