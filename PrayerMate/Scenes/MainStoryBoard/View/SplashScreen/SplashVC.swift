//
//  LaunchVC.swift
//  Ataba
//
//  Created by eman shedeed on 9/7/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

/// This is a class created for handling Custom Splash Screen
final class SplashVC: UIViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet weak var loadingView: UIView!
    
    //MARK:- Variables

    lazy private var activityIndicator : SYActivityIndicatorView = {
        let image = UIImage.loading
        return SYActivityIndicatorView(image: UIImage.loading,title: "loader.messageTitle".localized)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //   print(UIFont.systemFont(ofSize: 15).fontName)
        let presenter = SplashVCPresenter()
        presenter.setupUserDefaults()
        //  presenter.getUIFonts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.loadingView.center
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            //            UserDefaults.standard.set(nil, forKey:"appLanguage" )
            //            UserDefaults.standard.set(false, forKey:"userLocation" )
            if AppSetting.shared.getCurrentLanguage() != nil{
                
                if let _ = UserDefaults.standard.value(forKey: "userLocation") as? [String:Double]{
                    
                    let viewController = UIStoryboard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    
                    self.present(viewController, animated: true, completion:nil)
                    
                }else{
                    
                    let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                    
                    self.present(viewController, animated: true, completion:nil)
                }
                
            }else{
                self.performSegue(withIdentifier: "goToLanguageVC", sender: self)
            }
        }
    }
}
