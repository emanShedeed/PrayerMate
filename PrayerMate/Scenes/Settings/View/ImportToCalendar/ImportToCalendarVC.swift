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
class ImportToCalendarVC: UIViewController {
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var doneBtn: RoundedButton!
    @IBOutlet var checkBtns: [UIButton]!
    
    @IBOutlet var checkTitleLbl: [UILabel]!
     private let scopes = [kGTLRAuthScopeCalendar]
      private let service = GTLRCalendarService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        doneBtn.applyGradient(with:  [UIColor.init(rgb: 0x006666), UIColor.init(rgb: 0x339966)], gradient: .topLeftBottomRight)
        checkBtns.forEach { (button) in
            button.setImage(UIImage.uncheckCalendar, for: .normal)
            button.setImage(UIImage.checkCalendar, for: .selected)
        }
        /// google
        GIDSignIn.sharedInstance().clientID = "869556618508-cfup3e2uapcih6kcanfeacq7rl0hpri9.apps.googleusercontent.com"
                   GIDSignIn.sharedInstance().delegate = self
                   GIDSignIn.sharedInstance().scopes = scopes
                   GIDSignIn.sharedInstance()?.presentingViewController = self
        /////
    }
    
    
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
        let filteredIndices = checkBtns.indices.filter {checkBtns[$0].isSelected == true}
        print(filteredIndices)
        if filteredIndices.contains(0) {
            print("Apple Checked")
        }
        if filteredIndices.contains(1) {
            print("Google Checked")
            GIDSignIn.sharedInstance().signIn()
        }
        if filteredIndices.contains(2) {
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
           self.service.authorizer = user.authentication.fetcherAuthorizer()
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
                    UserDefaults.standard.set(token!, forKey: "icrosoftAuthorization")
                    print("MS signed in")
    //                self.createEvent(token:token!)
//                    self.getCalenderID(token: self.token)
//                    self.performSegue(withIdentifier: "userSignedIn", sender: nil)
                }
            }
        }
}
