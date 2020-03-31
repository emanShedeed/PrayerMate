//
//  CalendarMethodVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/30/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
protocol CalendarMethodVCView:class {
    func didSelectMethod()
}
class CalendarMethodVC: UIViewController {
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var calendarMethodTV:UITableView!
    
     weak var toSettingelegate : CalendarMethodVCView?
    let calendarMethodArray :[String] = ["CalendarMethod.egyptianGeneralAuthorityOfSurveyTitle".localized,"CalendarMethod.universityOfIslamicSciencesShafi".localized,"CalendarMethod.universityOfIslamicSciencesHanafi".localized,"CalendarMethod.islamicCircleOfNorthAmerica".localized,"CalendarMethod.muslimWorldLeague".localized,"CalendarMethod.ummAlQura".localized,"CalendarMethod.fixedIsha".localized]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        calendarMethodTV.tableFooterView=UIView()
        // For remove last separator
        calendarMethodTV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: calendarMethodTV.frame.size.width, height: 1))
    }
    
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CalendarMethodVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarMethodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarMethodCell", for: indexPath) as! CalendarMethodCell
        cell.methodNameLbl.text=calendarMethodArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = calendarMethodArray[indexPath.row]
        let dect:[String:String]=["methodName":name ,"methdID":"\(indexPath.row+1)"]
        UserDefaults.standard.set(dect, forKey: "calendarMethod")
        toSettingelegate?.didSelectMethod()
        self.dismiss(animated: true, completion: nil)
    }
    
}
