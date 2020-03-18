//
//  LaunchVC.swift
//  Ataba
//
//  Created by eman shedeed on 9/7/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    lazy private var activityIndicator : SYActivityIndicatorView = {
        let image = UIImage.loading
        return SYActivityIndicatorView(image: UIImage.loading,title: "loader.messageTitle".localized)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        print(UIFont.systemFont(ofSize: 15).fontName)
        //  getUIFonts()
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.loadingView.center
        activityIndicator.startAnimating()
        ///
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let ـ = AppSetting.shared.getCurrentLanguage(){
                let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(viewController, animated: true, completion:nil)
            }else{
//                self.present(AppLanguageViewController.instantiate(fromAppStoryboard: .main), animated: false, completion: nil)
                  self.performSegue(withIdentifier: "goToLanguageVC", sender: self)
            }
        }
        
        
    }
    
    //    func getUIFonts(){
    //        for name in UIFont.familyNames{
    //            print(name)
    //            for typeFace in UIFont.fontNames(forFamilyName: name){
    //                print(typeFace)
    //            }
    //        }
    //    }
}
