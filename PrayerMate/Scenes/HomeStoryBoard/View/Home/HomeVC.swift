//
//  HomeVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var selectedPrayerTimeName: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    var addressTitle : String!
    var presenter:HomeVCPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter = HomeVCPresenter(view: self)
//        prayerTimesArray=[(isCellSelected: Bool,Bool)]
        prayerTimestableView.backgroundColor = UIColor.clear
        importBtn.addBlurEffect()
        formateDate()
        let urlString="https://muslimsalat.com/"+addressTitle+"/yearly/22-03-2020/false/1.json?key=48ae8106ef6b55e5dac258c0c8d2e224"
        let url = URL(string: urlString)
        if let final_url = url{
            presenter.dataRequest(FINAL_URL:final_url)
        }
    }
    
    
    func formateDate(){
        // input date in given format (as string)
        //        let inputDateAsString = "2016-03-09 10:33:59"
        
        // initialize formatter and set input date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        // read input date string as NSDate instance
        if let date = formatter.date(from: myString) {
            
            // set locale to "ar_DZ" and format as per your specifications
            if AppSetting.shared.getCurrentLanguage() == AppLanguages.ar{
                formatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
            }
            formatter.dateFormat = "MMMM dd, yyyy "
            let outputDate = formatter.string(from: date)
            
            print(outputDate)
            dateLBL.text = outputDate
        }
    }
}
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "PrayerTimeCell", for: indexPath)as! PrayerTimeCell
        presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row].isCellSelected,isChecked:prayerTimesArray[indexPath.row].isBtnChecked,cellIndex:indexPath.row)
        cell.cellDelegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToRoomDetailsVC", sender: self)
        for index in 0 ..< prayerTimesArray.count {
            prayerTimesArray[index].isCellSelected = false
        }
        prayerTimesArray[indexPath.row].isCellSelected = true
        prayerTimesArray[indexPath.row].isBtnChecked = true
        prayerTimestableView.reloadData()
    }
    
    
    
    
}
