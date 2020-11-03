//
//  SettingVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/29/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
/// This is a class created for handling App Settings
class SettingViewController: UIViewController {
    
    //MARK:- IBOUTLET
    @IBOutlet var settingsTableView: UITableView!
    
    //MARK:VARiIABLES
    
    var SettingsArray :[(image: UIImage, name: String , value:String)] = .init()
    
    var delegateToHome:settingsVCView?
    
    let presenter = SettingPresenter()
    var isApiParameterUpdated : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        settingsTableView.tableFooterView=UIView()
        
        // For remove last separator
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        // for adding space at the end of table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        settingsTableView.contentInset = insets
        
        SettingsArray = presenter.setDefaultValues()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func backButtinPressed(_ sender: UIButton) {
         if(isApiParameterUpdated){
        delegateToHome?.APIParameterChanged()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension SettingViewController:UITableViewDataSource,UITableViewDelegate{
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
            self.present(self.presenter.createActionSheet(), animated: true) {
                print("option menu presented")
            }
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
            let dVC=segue.destination as! CalendarMethodViewController
            dVC.toSettingelegate=self
        }
        if(segue.identifier == "goToSettingsLocationVC"){
            let dVC=segue.destination as! SettingsLocationViewController
            dVC.toSettingelegate=self
        }
        if(segue.identifier == "goToImportToCalendarVC"){
            let dVC=segue.destination as! ImportToCalendarViewController
            dVC.toSettingelegate=self
        }
    }
}


