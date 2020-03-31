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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        settingsTableView.tableFooterView=UIView()
        // For remove last separator
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        
        let method = UserDefaults.standard.value(forKey: "calendarMethod") as? [String:String]
        let methodName = method?["methodName"]
        SettingsArray = [(image:UIImage.settingsLocation!,name:"Settings.location".localized,value:""),(image:UIImage.language!,name:"Settings.language".localized,value:""),(image:UIImage.clock!,name:"Settings.prayerTimeBuffer".localized,value:""),(image:UIImage.calendar!,name:"Settings.importToCalendar".localized,value:""),(image:UIImage.method!,name:"Settings.calendarMethod".localized,value:methodName ?? ""),(image:UIImage.hourclock!,name:"Settings.about".localized,value:""),(image:UIImage.faq!,name:"Settings.faqs".localized,value:""),(image:UIImage.invite!,name:"Settings.inviteFriends".localized,value:"")]
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
        if(indexPath.row == 4){
            performSegue(withIdentifier: "goToCalendarMethod", sender: nil)
        }
        else if(indexPath.row == 5){
            performSegue(withIdentifier: "goToAboutC", sender: nil)
        }
        else if(indexPath.row == 6){
            performSegue(withIdentifier: "goToFrequentlyQuestionsVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToCalendarMethod"){
           let dVC=segue.destination as! CalendarMethodVC
            dVC.toSettingelegate=self
        }
    }
}
