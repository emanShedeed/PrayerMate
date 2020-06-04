//
//  HomeVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

/// This is a class created for handling the Home View of the app , displaying Prayer Times and Import to calendar Function
final class HomeViewController: BaseViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var selectedPrayerTimeName: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!

    
    //MARK:VARiIABLES
 
    let countDownTimerFormatter = DateFormatter()
    var countdown: DateComponents!
    let calendar = Calendar.current
    var nextPrayerDateDate: Date!
  
    var presenter:HomePresenter!
    var prayerTimesArray: [Bool] = .init()
    var backGroundImagesArray = [UIImage.fajrBackGround,UIImage.sunriseBackGround,UIImage.zuhrBackGround,UIImage.asrBackGround,UIImage.maghribBackGround,UIImage.ishaBackGround]
//    var getNextDayTimes = false

    ///
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        presenter.requestPrayerTimesAPI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK:- Methods
    
    /**
     Call this function for setup the View UI
     
     
     ### Usage Example: ###
     ````
     setupView()
     
     ````
     - Parameters:
     */
    func setupView(){
   
        presenter = HomePresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"
        
        prayerTimestableView.backgroundColor = UIColor.clear
        dateLBL.text = presenter.formateTodayDate()
    }
    
 
    
    //MARK:- IBActions
    @IBAction func importBtnPressed(_ sender: Any) {
 
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if let viewController = UIStoryboard.Settings.instantiateInitialViewController() as? UINavigationController {
            let settingsVC = viewController.viewControllers[0] as? SettingViewController
            settingsVC?.delegateToHome = self
            self.show(viewController, sender: self)
        }
    }
    

    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "HomePrayerTimeCell", for: indexPath)as! HomePrayerTimeCell
        presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row],cellIndex:indexPath.row)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToRoomDetailsVC", sender: self)
      
        backGroundImageView.image=backGroundImagesArray[indexPath.row]
        for index in 0 ..< prayerTimesArray.count {
            prayerTimesArray[index] = false
        }
        prayerTimesArray[indexPath.row] = true
        prayerTimestableView.reloadData()
    }
    
    
    
}
/// This is a class created for handling Methods for update counter
extension HomeViewController{
    /**
     Call this function for update Time remain for the next Prayer Time
     
     
     
     ### Usage Example: ###
     ````
     Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
     
     ````
     - Parameters:
     */
    @objc func updateTime() {
        let dateAsString = countDownTimerFormatter.string(from: Date())
        self.countdown = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: countDownTimerFormatter.date(from: dateAsString) ?? Date() , to: self.nextPrayerDateDate)
        let hours = countdown.hour!
        let minutes = countdown.minute!
        let seconds = countdown.second!
        print( String(format: "%02d:%02d:%02d",  hours, minutes, seconds))
        remainingTimeLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        if(remainingTimeLbl.text == "00:00:00" ){
            getNextPrayerTime()
        }
        
    }
    /**
     Call this function for create timer to call updateTime function every one Second
     
     
     
     ### Usage Example: ###
     ````
     runCountdown()
     
     ````
     - Parameters:
     */
    func runCountdown() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    /**
     Call this function for get Next Prayer Time
     
     
     
     ### Usage Example: ###
     ````
     getNextPrayerTime()
     
     ````
     - Parameters:
     */
    func getNextPrayerTime(){
        var nextPrayerIndex = 0
        var IsfajrOfNextDate = false
        var accurateString :String = ""
      
//        if(getNextDayTimes){
//            presenter.requestPrayerTimesAPI()
//            getNextDayTimes = false
//        }
        for  i in 0..<presenter.todayParyerTimes.count {
            accurateString = presenter.getPrayerTimeAccurateString(time: presenter.todayParyerTimes[i])
            let dateAsString = countDownTimerFormatter.string(from: Date())
            if(i == 0 ){
                let diff = Helper.findDateDiff(time1Str: presenter.getPrayerTimeAccurateString(time: presenter.todayParyerTimes[5]), time2Str: dateAsString, isNextDayFajr: IsfajrOfNextDate)
                if(!diff.contains("-") ){
                    IsfajrOfNextDate = true
//                    getNextDayTimes = true
                }
            }
            let dateDiff = Helper.findDateDiff(time1Str: dateAsString, time2Str: accurateString, isNextDayFajr: IsfajrOfNextDate)
            if(!dateDiff.contains("-") ){
                nextPrayerIndex = i
                backGroundImageView.image=backGroundImagesArray[i]
                prayerTimesArray[nextPrayerIndex] = true
                self.prayerTimestableView.reloadData()
                break
            }
            
        }
        
        
        var tempString = accurateString.replacingOccurrences(of: " PM", with: "")
        tempString = tempString.replacingOccurrences(of: " AM", with: "")
        var dateComponent = tempString.split(separator: ":")
        
        if(accurateString.contains("PM")){
            let hours = Int(dateComponent[0]) ?? 0
            if (hours < 12) {
                dateComponent[0] = "\(hours + 12)"
            }
        }
        nextPrayerDateDate = {
            let future = DateComponents(
                year: calendar.component(.year, from: Date()),
                month: calendar.component(.month, from: Date()),
                day: calendar.component(.day, from: Date()),
                hour: Int(dateComponent[0]),
                minute: Int(dateComponent[1]),
                second: Int(dateComponent[2])
            )
            return Calendar.current.date(from: future)!
        }()
        
        DispatchQueue.main.async {
            self.selectedPrayerTimeName.text=self.presenter.prayerTimesNames[nextPrayerIndex].localized
            self.prayerTimesArray[nextPrayerIndex] = true
            self.runCountdown()
        }
    }
    
}




