//
//  SettingVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/29/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    @IBOutlet var settingsTableView: UITableView!
    var SettingsArray :[(image: UIImage, name: String , value:String)] = .init()
    var delegateToHome:settingsVCView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        settingsTableView.tableFooterView=UIView()
        // For remove last separator
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        
        let method = UserDefaults.standard.value(forKey: "calendarMethod") as? [String:String]
        let calendars = UserDefaults.standard.value(forKey: "choosenCalendars") as? [Int]
        var calendarName = ""
        if(calendars?.count ?? 0 > 0){
            if (calendars?.first == 0){
                calendarName =  "ImportToCalendarVC.appleLbl".localized
            } else if calendars?.first == 1{
                calendarName = "ImportToCalendarVC.googleLbl".localized
            } else if calendars?.first == 2 {
                calendarName = "ImportToCalendarVC.MSLbl".localized
            }
        }
        let methodName = method?["methodName"]?.localized
        let addressTitle = UserDefaults.standard.value(forKey: "addressTitle") as? String ?? ""
        SettingsArray = [(image:UIImage.settingsLocation!,name:"Settings.location".localized,value:addressTitle),(image:UIImage.language!,name:"Settings.language".localized,value:"language".localized),(image:UIImage.clock!,name:"Settings.prayerTimeBuffer".localized,value:""),(image:UIImage.calendar!,name:"Settings.importToCalendar".localized,value:calendarName),(image:UIImage.method!,name:"Settings.calendarMethod".localized,value:methodName ?? ""),(image:UIImage.hourclock!,name:"Settings.about".localized,value:""),(image:UIImage.faq!,name:"Settings.faqs".localized,value:""),(image:UIImage.invite!,name:"Settings.inviteFriends".localized,value:"")]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backButtinPressed(_ sender: UIButton) {
        delegateToHome?.APIParameterChanged()
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SettingVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.settingIcon.image=SettingsArray[indexPath.row].image
        cell.nameLbl.text=SettingsArray[indexPath.row].name
        cell.valueLbl.text=SettingsArray[indexPath.row].value
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            performSegue(withIdentifier: "goToSettingsLocationVC", sender: nil)
        }
        if(indexPath.row == 1){
            createActionSheet()
        }
        if(indexPath.row == 2){
            performSegue(withIdentifier: "goToPrayerTimeBufferVC", sender: nil)
        }
        if(indexPath.row == 3){
            performSegue(withIdentifier: "goToImportToCalendarVC", sender: nil)
        }
        if(indexPath.row == 4){
            performSegue(withIdentifier: "goToCalendarMethod", sender: nil)
        }
        else if(indexPath.row == 5){
            performSegue(withIdentifier: "goToAboutC", sender: nil)
        }
        else if(indexPath.row == 6){
            performSegue(withIdentifier: "goToFrequentlyQuestionsVC", sender: nil)
        }
        else if(indexPath.row == 7){
            if let urlStr = URL(string: "https://itunes.apple.com/us/app/myapp/id1505753464?ls=1&mt=8"), !urlStr.absoluteString.isEmpty {
                let objectsToShare = [urlStr]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                
                self.present(activityVC, animated: true, completion: nil)
            }else  {
                // show alert for not available
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToCalendarMethod"){
            let dVC=segue.destination as! CalendarMethodVC
            dVC.toSettingelegate=self
        }
        if(segue.identifier == "goToSettingsLocationVC"){
            let dVC=segue.destination as! SettingsLocationVC
            dVC.toSettingelegate=self
        }
        if(segue.identifier == "goToImportToCalendarVC"){
            let dVC=segue.destination as! ImportToCalendarVC
            dVC.toSettingelegate=self
        }
    }
}
extension SettingVC{
    func createActionSheet(){
        let actionSheetController=UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        // create an action
        let englishAction = UIAlertAction(title: "Language.en".localized, style: .default) { action -> Void in
            if(AppSetting.shared.getCurrentLanguage() == AppLanguages.ar){
                AppSetting.shared.setCurrentLanguage(language: AppLanguages.en)
                LanguageManager.currentLanguage=AppLanguages.en.rawValue
                self.reloadRootView()
            }
        }
        englishAction.setValue(UIColor.black, forKey: "titleTextColor")
        // create an action
        let arabicAction = UIAlertAction(title: "Language.ar".localized, style: .default) { action -> Void in
            if(AppSetting.shared.getCurrentLanguage() == AppLanguages.en){
                AppSetting.shared.setCurrentLanguage(language: AppLanguages.ar)
                LanguageManager.currentLanguage=AppLanguages.ar.rawValue
                self.reloadRootView()
            }
        }
        arabicAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        // create an action
        let doneAction = UIAlertAction(title: "Language.done".localized, style: .cancel) { action -> Void in }
        doneAction.setValue(UIColor(rgb: 0xEA961E), forKey: "titleTextColor")
        
        // add actions
        actionSheetController.addAction(englishAction)
        actionSheetController.addAction(arabicAction)
        actionSheetController.addAction(doneAction)
        
        self.present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    private func reloadRootView() {
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = UIStoryboard.main.instantiateInitialViewController()
        }
    }
}
