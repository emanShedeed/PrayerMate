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
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         IQKeyboardManager.shared().isEnabled = true
        //
        UNUserNotificationCenter.current().delegate=self
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsConstants.isLaunchedBefore)
     if launchedBefore  {
        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.isLaunchedBefore)
     } else {
         print("First launch, setting UserDefault.")
         UserDefaults.standard.set(false, forKey: UserDefaultsConstants.isLaunchedBefore)
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
       switch response.actionIdentifier {
           case "OkAction":
            print("ok")
            let formatter=DateFormatter()
            formatter.locale=NSLocale(localeIdentifier: "en") as Locale
            formatter.dateFormat = "yyyy-M-d"
            let exortingPeriod = UserDefaults.standard.value(forKey: UserDefaultsConstants.selectedExortingPeriod) as! Int
            let firstDate = Calendar.current.date(byAdding: .day, value: 2 , to: Date())
            let secondDate = Calendar.current.date(byAdding: .day, value: exortingPeriod - 1 , to: firstDate ?? Date())
            let presenter:ExportingPresenter!
            presenter = ExportingPresenter(view: self)
            presenter.importPrayerTimesToSelectedCalendars(importStartDateAsString: formatter.string(from: firstDate ?? Date()), importEndDateAsString: formatter.string(from:secondDate ?? Date()))
        break
        
           case "CancelAction":
              print("cancel")
              break
                
           // Handle other actions…
         
           default:
              break
           }
            
           // Always call the completion handler when done.
           completionHandler()
     }
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.alert, .badge, .sound])
     }
     
    // MARK: UISceneSession Lifecycle
    // microsoft calendar
}

extension AppDelegate:ExportingViewControllerProtocol{
    func imoprtToCalendarsSuccess() {
    print("succeed")
    }
    
 
    
}
