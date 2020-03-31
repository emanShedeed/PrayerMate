//
//  MovesVC.swift
//  Ataba
//
//  Created by eman shedeed on 12/11/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
//    @IBOutlet weak var movesTableView: FullHeightTableView!{ didSet{
//          movesTableView.contentSizeChanged = {
//              [weak self] newHeight in
//            if(newHeight > UIScreen.main.bounds.size.height - 120){
//                self?.tableViewHeight.constant =  UIScreen.main.bounds.size.height - 180
//                self?.containerViewHeight.constant =  UIScreen.main.bounds.size.height - 100
//            }else{
//              self?.tableViewHeight.constant = newHeight + 20
//            self?.containerViewHeight.constant = newHeight + 100
//            }
//          }
//          }
//      }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          roundedView.roundCorners([.topLeft,.topRight], radius: 20)
    }
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
