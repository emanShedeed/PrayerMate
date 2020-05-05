//
//  CalendarMethodVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/30/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
/// This is a protcol created for update settings VC if any Parameter change
protocol UpdateSettingsProtcol:class {
    func didUpdateSettings()
}
/// This is a class created for handling the Calendar Method types
class CalendarMethodViewController: UIViewController {
    
     //MARK:- IBOUTLET
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var calendarMethodTV:UITableView!
    
     //MARK:VARiIABLES
    
    weak var toSettingelegate : UpdateSettingsProtcol?
    
    let calendarMethodArray :[String] = ["CalendarMethod.egyptianGeneralAuthorityOfSurveyTitle","CalendarMethod.universityOfIslamicSciencesShafi","CalendarMethod.universityOfIslamicSciencesHanafi","CalendarMethod.islamicCircleOfNorthAmerica","CalendarMethod.muslimWorldLeague","CalendarMethod.ummAlQura","CalendarMethod.fixedIsha"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        calendarMethodTV.tableFooterView=UIView()
        // For remove last separator
        calendarMethodTV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: calendarMethodTV.frame.size.width, height: 1))
    }
    
    //MARK:- IBActions
    
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

/// This is a class created for handling table View delegate and data source delegate functions
extension CalendarMethodViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarMethodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarMethodCell", for: indexPath) as! CalendarMethodCell
        cell.methodNameLbl.text=calendarMethodArray[indexPath.row].localized
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = calendarMethodArray[indexPath.row]
        let dect:[String:String]=["methodName":name ,"methdID":"\(indexPath.row+1)"]
        UserDefaults.standard.set(dect, forKey:UserDefaultsConstants.calendarMethod)
        toSettingelegate?.didUpdateSettings()
        self.dismiss(animated: true, completion: nil)
    }
    
}
