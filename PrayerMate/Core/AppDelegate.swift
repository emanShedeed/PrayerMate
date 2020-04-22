//
//  AppDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 2/25/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import GoogleSignIn
import MSAL
import IQKeyboardManager
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         IQKeyboardManager.shared().isEnabled = true
        //
     let launchedBefore = UserDefaults.standard.bool(forKey: "isLaunchedBefore")
     if launchedBefore  {
        UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
     } else {
         print("First launch, setting UserDefault.")
         UserDefaults.standard.set(false, forKey: "isLaunchedBefore")
     }
        return true
    }
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        
        return GIDSignIn.sharedInstance().handle(url) || MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: sourceApplication)
    }
    // MARK: UISceneSession Lifecycle
    
  
    // microsoft calendar
    
}

