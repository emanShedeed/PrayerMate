//
//  ImportToCalendarVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/1/20.
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

/// This is a class created for choosing Calenders User need to import to
class ImportToCalendarVC: UIViewController {
     //MARK:- IBOUTLET
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var doneBtn: RoundedButton!
    @IBOutlet var checkBtns: [UIButton]!
    @IBOutlet var checkTitleLbl: [UILabel]!
    
    //MARK:VARiIABLES
    
    //Google
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    ///
    
    var filteredIndices = [Int].init()
    var choosenCalendars = [Int].init()
     weak var toSettingelegate : UpdateSettingsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
      setupView()
      displaySelectedCalendars()
      setupGoogleConfiguration()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         doneBtn.applyGradient(with:  [UIColor.init(rgb: 0x006666), UIColor.init(rgb: 0x339966)], gradient: .topLeftBottomRight)
    }
    /**
                   Call this function setup UI
                  
                     
                   ### Usage Example: ###
                   ````
                 setupView()
                   
                   ````
               - Parameters:
                   */
    func setupView(){
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
             
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
        let calendars = UserDefaults.standard.value(forKey: "choosenCalendars") as? [Int]
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
        GIDSignIn.sharedInstance().clientID = "869556618508-cfup3e2uapcih6kcanfeacq7rl0hpri9.apps.googleusercontent.com"
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
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
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
            }else {
                UserDefaults.standard.set(choosenCalendars, forKey: "choosenCalendars")
                toSettingelegate?.didUpdateSettings()
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if filteredIndices.contains(1) {
            print("Google Checked")
            GIDSignIn.sharedInstance().signIn()
        }
        else if filteredIndices.contains(2) {
            print("MS Checked")
            signInMicrosoftAccount()
        }
        
    }
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:Google SignIn
extension ImportToCalendarVC:GIDSignInDelegate{
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
            Helper.showAlert(title: "Authentication Error", message: error.localizedDescription, VC: self)
            //            self.service.authorizer = nil
        } else {
            print("signed into google")
                Helper.showToast(message: "ImportToCalendarVC.GoogleSignInSuccessMessage".localized)
            choosenCalendars.append(1)
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            if filteredIndices.contains(2) {
                print("MS Checked")
                signInMicrosoftAccount()
            }else{
                UserDefaults.standard.set(choosenCalendars, forKey: "choosenCalendars")
                toSettingelegate?.didUpdateSettings()
                self.dismiss(animated: true, completion: nil)
            }
            //            UserDefaults.standard.set(service, forKey: "googleAuthentaication")
            
            //            addEventoToGoogleCalendar(summary: "test repetation", description: "description", startTime: "08/03/2020 15:00", endTime: "08/03/2020 17:00")
        }
    }
    
}
//MARK:Microsoft SignIn
extension ImportToCalendarVC{
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
                    let alert = UIAlertController(title: "Error signing in",
                                                  message: error.debugDescription,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                // Signed in successfully
                // Go to welcome page
                //                    self.token = token!
                Helper.showToast(message: "ImportToCalendarVC.MSSignInSuccessMessage".localized)
                self.choosenCalendars.append(2)
                UserDefaults.standard.set(token!, forKey: "icrosoftAuthorization")
                print("MS signed in")
                UserDefaults.standard.set(self.choosenCalendars, forKey: "choosenCalendars")
                self.toSettingelegate?.didUpdateSettings()
                self.dismiss(animated: true, completion: nil)
                //                self.createEvent(token:token!)
                //                    self.getCalenderID(token: self.token)
                //                    self.performSegue(withIdentifier: "userSignedIn", sender: nil)
            }
        }
    }
    func signOut() {
        AuthenticationManager.instance.signOut()
        //        self.performSegue(withIdentifier: "userSignedOut", sender: nil)
    }
}
