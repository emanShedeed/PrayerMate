//
//  CalendarViewController.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/8/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
//Google
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
//Microsoft Calendar
import MSGraphClientSDK
import MSGraphClientModels

class CalendarViewController: UIViewController {
    @IBOutlet weak var animatedImage: UIImageView!
    @IBOutlet weak var animatedImage2: UIImageView!
    @IBOutlet weak var animatedImageLeading: NSLayoutConstraint!
    @IBOutlet weak var animatedImageTrailing: NSLayoutConstraint!
    @IBOutlet var checkBtns: [UIButton]!
    @IBOutlet var checkTitleLbl: [UILabel]!
    
    //MARK:VARiIABLES
    
    //Google
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    ///
    
    var filteredIndices = [Int].init()
    var choosenCalendars = [Int].init()
    var viewController :UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        displaySelectedCalendars()
        setupGoogleConfiguration()
        viewController = UIStoryboard.Home.instantiateInitialViewController() as! UINavigationController
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationcomeFromBackGround),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackGround()
    }
    @objc func applicationcomeFromBackGround(){
        animateBackGround()
    }
    
    //MARK:- Methods
     
     private func animateBackGround(){
         
         UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
             
            /*  self.animatedImage.frame = self.animatedImage.frame.offsetBy(dx: 1 * self.animatedImage.frame.size.width, dy: 0.0)
                        self.animatedImage2.frame = self.animatedImage2.frame.offsetBy(dx: 1 * self.animatedImage2.frame.size.width, dy: 0.0)
             */
             
             self.animatedImageLeading.constant += self.animatedImage.frame.width
             
             self.animatedImageTrailing.constant += self.animatedImage.frame.width
             
             self.view.layoutIfNeeded()
             
         }, completion: nil)
     }
    /**
     Call this function to display selected Calendars if any
     
     
     ### Usage Example: ###
     ````
     displaySelectedCalendars()
     
     ````
     - Parameters:
     */
    func displaySelectedCalendars(){
        let calendars = UserDefaults.standard.value(forKey: UserDefaultsConstants.choosenCalendars) as? [Int]
        for (index, button) in checkBtns.enumerated() {
            if(calendars?.contains(index) ?? false){
                button.isSelected = true
                checkTitleLbl[index].textColor=UIColor.appColor
            }
            button.setImage(UIImage.uncheckCalendar, for: .normal)
            button.setImage(UIImage.checkCalendar, for: .selected)
        }
    }
    /**
     Call this function to setup Google Configuration
     
     
     ### Usage Example: ###
     ````
     setupGoogleConfiguration()
     
     ````
     - Parameters:
     */
    func setupGoogleConfiguration(){
        //         GIDSignIn.sharedInstance().clientID = "869556618508-cfup3e2uapcih6kcanfeacq7rl0hpri9.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = "869556618508-am9aqj0pn1i39qdovfumf9imfcru9j6u.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    //MARK:- IBActions
    
    @IBAction func checkBtnPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let index = checkBtns.firstIndex(where: {$0 == sender}){
            if(sender.isSelected){
                checkTitleLbl[index].textColor = UIColor.appColor
            }else{
                checkTitleLbl[index].textColor = UIColor(rgb: 0x3C3C3C)
            }
        }
        
    }
    
    @IBAction func FinishBtnPressed(_ sender: Any) {
        choosenCalendars = [Int].init()
        filteredIndices = checkBtns.indices.filter {checkBtns[$0].isSelected == true}
        print(filteredIndices)
        
        if filteredIndices.contains(0) {
            print("Apple Checked")
            choosenCalendars.append(0)
            if filteredIndices.contains(1) {
                GIDSignIn.sharedInstance().signIn()
            }else if filteredIndices.contains(2){
                signInMicrosoftAccount()
            }
            else {
                UserDefaults.standard.set(choosenCalendars, forKey: UserDefaultsConstants.choosenCalendars)
             self.present(viewController, animated: true, completion:nil)
            }
        }
        else if filteredIndices.contains(1) {
            GIDSignIn.sharedInstance().signIn()
        }
        else if filteredIndices.contains(2) {
            print("MS Checked")
            signInMicrosoftAccount()
        }
        
        if(filteredIndices.count == 0){
            Helper.showToast(message: "CalendarVC.toastLbl".localized)
            return
        }
        
        //        choosenCalendars = filteredIndices
        //        UserDefaults.standard.set(choosenCalendars, forKey: "choosenCalendars")
        //        toSettingelegate?.didUpdateSettings()
        //        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK:Google SignIn
extension CalendarViewController:GIDSignInDelegate{
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    ////Google_signIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            //            showAlert(title: "Authentication Error", message: )
            Helper.showAlert(title: "CalendarVC.SigningInproblemAlertTitle".localized, message:"CalendarVC.GoogleSigningInproblemAlertDesc".localized, VC: self)
            //            self.service.authorizer = nil
        } else {
            print("signed into google")
            Helper.showToast(message: "CalendarVC.GoogleSignInSuccessMessage".localized)
            choosenCalendars.append(1)
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            let googleService = GoogleService(authorizers: user.authentication.fetcherAuthorizer())
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: googleService)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsConstants.googleService)
            UserDefaults.standard.synchronize()
            if filteredIndices.contains(2) {
                print("MS Checked")
                signInMicrosoftAccount()
            }else{
                UserDefaults.standard.set(choosenCalendars, forKey: UserDefaultsConstants.choosenCalendars)
//                toSettingelegate?.didUpdateCalendarName()
//                self.dismiss(animated: true, completion: nil)
                self.present(viewController, animated: true, completion:nil)
            }
            //            UserDefaults.standard.set(service, forKey: "googleAuthentaication")
            
            //            addEventoToGoogleCalendar(summary: "test repetation", description: "description", startTime: "08/03/2020 15:00", endTime: "08/03/2020 17:00")
        }
    }
}
//MARK:Microsoft SignIn
extension CalendarViewController{
    func signInMicrosoftAccount() {
        //         spinner.start(container: self)
        
        // Do an interactive sign in
        //        signOut()
        AuthenticationManager.instance.getTokenInteractively(parentView: self) {
            (token: String?, error: Error?) in
            
            DispatchQueue.main.async {
                //                 self.spinner.stop()
                
                guard let _ = token, error == nil else {
                    // Show the error and stay on the sign-in page
                    let alert = UIAlertController(title: "CalendarVC.SigningInproblemAlertTitle".localized,
                                                  message: "CalendarVC.MicrosoftSigningInproblemAlertDesc".localized ,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                // Signed in successfully
                // Go to welcome page
                //                    self.token = token!
                Helper.showToast(message: "CalendarVC.MSSignInSuccessMessage".localized)
                self.choosenCalendars.append(2)
                UserDefaults.standard.set(token!, forKey: UserDefaultsConstants.microsoftAuthorization)
                print("MS signed in")
                UserDefaults.standard.set(self.choosenCalendars, forKey: UserDefaultsConstants.choosenCalendars)
             
                self.present(self.viewController, animated: true, completion:nil)
                
                //                self.createEvent(token:token!)
                self.getCalenderID(token: token!)
                //                    self.performSegue(withIdentifier: "userSignedIn", sender: nil)
            }
        }
    }
    func getCalenderID(token: String) {
        let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)
        let token = UserDefaults.standard.value(forKey: UserDefaultsConstants.microsoftAuthorization) as! String
        let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
        var urlRequest: NSMutableURLRequest? = nil
        if let url = URL(string: MSGraphBaseURL + ("/me/calendar")) {
            urlRequest = NSMutableURLRequest(url: url)
        }
        urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest?.httpMethod = "GET"
        
        var meDataTask: MSURLSessionDataTask? = nil
        if let urlRequest = urlRequest {
            meDataTask = httpClient?.dataTask(with: urlRequest, completionHandler: { data, response, nserror in
                
                var calendar: MSGraphCalendar? = nil
                do {
                    if let data = data {
                        calendar = try MSGraphCalendar(data: data)
                        if let id = calendar?.entityId{
                            //                                self.calendarId = id
                            //                                self.MicrosoftCalendarID = id
                            UserDefaults.standard.set(id, forKey: UserDefaultsConstants.microsoftCalendarID)
                            //                            self.createEventToMicrosoftCalendar(calendarId: id, title: "it's Fajr time", description: "", eventStartDate:"" , eventEndDate: "" , tillDate: "")
                        }
                    }
                } catch let nserror {
                    print(nserror)
                }
                
            })
        }
        
        meDataTask?.execute()
        
    }
    func signOut() {
        AuthenticationManager.instance.signOut()
        //        self.performSegue(withIdentifier: "userSignedOut", sender: nil)
    }
}
