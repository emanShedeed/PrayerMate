//
//  HomeVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import JTAppleCalendar
/// This is a class created for handling the Home View of the app , displaying Prayer Times and Import to calendar Function
final class HomeVC: UIViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var selectedPrayerTimeName: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    //// Calendar IBOUTLET
    @IBOutlet weak var calendarDateTitleLbl: UILabel!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var calenadrIncludingHeaderView: UIView!
    @IBOutlet weak var hideCalendareView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    
    //MARK:VARiIABLES
    
    let countDownTimerFormatter = DateFormatter()
    var countdown: DateComponents!
    let calendar = Calendar.current
    var nextPrayerDateDate: Date!
    var numberOfSelectedPrayerTimes : Int = 0
    var addressTitle : String!
    var presenter:HomeVCPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    var backGroundImagesArray = [UIImage.fajrBackGround,UIImage.sunriseBackGround,UIImage.zuhrBackGround,UIImage.asrBackGround,UIImage.maghribBackGround,UIImage.ishaBackGround]
   
    ////Calendar VARiIABLES
    let calendareFormatter = DateFormatter()
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    lazy var activityIndicator : SYActivityIndicatorView = {
        let image = UIImage.loading
        return SYActivityIndicatorView(image: UIImage.loading,title: "loader.messageTitle".localized)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        
        requestPrayerTimesAPI()
        
        presenter.setupCalendarView(calendarView: calendarView, calenadrIncludingHeaderView: calenadrIncludingHeaderView, calendareFormatter: calendareFormatter)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        hideCalendareView.addGestureRecognizer(tap)
    }
    override func viewDidLayoutSubviews() {
        importBtn.addBlurEffect()
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
        calendarView.semanticContentAttribute = .forceRightToLeft
        daysStackView.semanticContentAttribute = .forceLeftToRight
        presenter = HomeVCPresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"
        
        prayerTimestableView.backgroundColor = UIColor.clear
        dateLBL.text = presenter.formateTodayDate()
    }
    /**
          Call this function for request Prayer Times API
       
            
          ### Usage Example: ###
          ````
          requestPrayerTimesAPI()
          
          ````
        - Parameters:
          */
    func requestPrayerTimesAPI(){
       let url = generateURL()
        if let final_url = url{
            self.view.addSubview(activityIndicator)
            activityIndicator.center = self.view.center
            activityIndicator.startAnimating()
            presenter.dataRequest(FINAL_URL:final_url)
        }
    }
    /**
           Call this function for generate URL required to call the API
         
             
           ### Usage Example: ###
           ````
           generateURL()
           
           ````
     - Parameters:
        - Return Type: URL
           */
    func generateURL() -> URL?{
     let date = generateDateStringSendToAPI()
       addressTitle = UserDefaults.standard.value(forKey: "addressTitle") as? String ?? ""
       let method = UserDefaults.standard.value(forKey: "calendarMethod") as! [String:String]
       let methodID = method["methdID"] ?? "6"
       let basicURL = "https://muslimsalat.com/" +  addressTitle + "/yearly/" + date
       let urlString = basicURL + "/false/" + methodID + ".json?key=48ae8106ef6b55e5dac258c0c8d2e224"
       print(urlString)
       let ecnodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       let url = URL(string: ecnodingString ?? "")
        return url
    }
    /**
             Call this function for generate Date String required to call the API
            
               
             ### Usage Example: ###
             ````
             generateDateStringSendToAPI()
             
             ````
           - Parameters:
            - Return Type : String
             */
    func generateDateStringSendToAPI() -> String{
        let dateFormatterForAPI = DateFormatter()
             dateFormatterForAPI.locale = NSLocale(localeIdentifier: "en")  as Locale
             dateFormatterForAPI.dateFormat = "dd-MM-YYYY"
             let date = dateFormatterForAPI.string(from: Date())
        return date
    }
    /**
                Call this function for hide calendare view
               
                  
                ### Usage Example: ###
                ````
               let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                       
               hideCalendareView.addGestureRecognizer(tap)
                
                ````
            - Parameters:
                    - sender: the tap Gesture Recognizer
                     - Return Type :
                */
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        calenadrIncludingHeaderView.isHidden = true
    }
    
    //MARK:- IBActions
    @IBAction func importBtnPressed(_ sender: Any) {
        if(numberOfSelectedPrayerTimes > 0){
            calenadrIncludingHeaderView.isHidden=false
        }
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if let viewController = UIStoryboard.Settings.instantiateInitialViewController() as? UINavigationController {
            let settingsVC = viewController.viewControllers[0] as? SettingVC
            settingsVC?.delegateToHome = self
            self.show(viewController, sender: self)
        }
    }
    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "PrayerTimeCell", for: indexPath)as! PrayerTimeCell
        presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row].isCellSelected,isChecked:prayerTimesArray[indexPath.row].isBtnChecked,cellIndex:indexPath.row)
        numberOfSelectedPrayerTimes = prayerTimesArray[indexPath.row].isBtnChecked ? numberOfSelectedPrayerTimes + 1 : numberOfSelectedPrayerTimes
        cell.cellDelegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToRoomDetailsVC", sender: self)
        numberOfSelectedPrayerTimes += 1
        backGroundImageView.image=backGroundImagesArray[indexPath.row]
        for index in 0 ..< prayerTimesArray.count {
            prayerTimesArray[index].isCellSelected = false
        }
        prayerTimesArray[indexPath.row].isCellSelected = true
        prayerTimesArray[indexPath.row].isBtnChecked = true
        prayerTimestableView.reloadData()
    }
    
    
    
    
}
/// This is a class created for handling Methods for update counter
extension HomeVC{
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
        for  i in 0..<presenter.todayParyerTimes.count {
         accurateString = getPrayerTimeAccurateString(index: i)
            let dateAsString = countDownTimerFormatter.string(from: Date())
            if(i == 0 ){
                let diff = Helper.findDateDiff(time1Str: getPrayerTimeAccurateString(index: 5), time2Str: dateAsString, isNextDayFajr: IsfajrOfNextDate)
                if(!diff.contains("-") ){
                    IsfajrOfNextDate = true
                }
            }
            let dateDiff = Helper.findDateDiff(time1Str: dateAsString, time2Str: accurateString, isNextDayFajr: IsfajrOfNextDate)
            if(!dateDiff.contains("-") ){
                nextPrayerIndex = i
                backGroundImageView.image=backGroundImagesArray[i]
                prayerTimesArray[nextPrayerIndex].isCellSelected = true 
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
            self.prayerTimesArray[nextPrayerIndex].isCellSelected = true
            self.runCountdown()
        }
    }
    func getPrayerTimeAccurateString(index : Int) -> String{
        var accurateString :String = ""
        accurateString = presenter.todayParyerTimes[index].count == 7 ? "0" + presenter.todayParyerTimes[index] : presenter.todayParyerTimes[index]
                   accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
                   accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
                   accurateString = accurateString.replacingOccurrences(of: " ", with: ":00 ")
        return accurateString
    }
}
/// This is a class created for handling JTAppleCalendar dataSource functions
extension HomeVC:JTACMonthViewDataSource{
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, calendar: Calendar(identifier: .gregorian), generateInDates: .off, generateOutDates: .off, firstDayOfWeek: .sunday)
        return parameters
    }
}
/// This is a class created for handling JTAppleCalendar delegate functions
extension HomeVC:JTACMonthViewDelegate{
    //Display the Cell
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomJTAppleCalendarCell
        presenter.configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell=calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomJTAppleCalendarCell", for: indexPath) as! CustomJTAppleCalendarCell
        cell.dayLabel.text = cellState.text
        presenter.handelCellSelectedColor(cell: cell, celssState: cellState)
        presenter.configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if firstDate != nil {
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
        }
        presenter.configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        presenter.configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        presenter.setupViewsOfCalendar(from: visibleDates)
        calendarDateTitleLbl.text = presenter.calendarDateTitle
    }
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool{
        let dateAsString = calendareFormatter.string(from: date)
        let currentDateAsString=calendareFormatter.string(from: Date())
        if(calendareFormatter.date(from: dateAsString)! < calendareFormatter.date(from: currentDateAsString)!){
            Helper.showToast(message: "Home.PreviousDateToasterMessage".localized)
            return false
        }
        
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
            firstDate = nil
            let retval = !calendarView.selectedDates.contains(date)
            calendarView.deselectAllDates(triggerSelectionDelegate: false)
            return retval
        }
        if( firstDate != nil && date > calendarView.selectedDates[0]){
            let firstDateAsString = calendareFormatter.string(from: firstDate!)
            let MaxDate =  Calendar.current.date(byAdding: .month, value: 1, to: calendareFormatter.date(from: firstDateAsString)!) ?? Date()
            let maxDateAsString = calendareFormatter.string(from: MaxDate)
            if(calendareFormatter.date(from: dateAsString)! > calendareFormatter.date(from: maxDateAsString)!){
                Helper.showToast(message:"Home.moreThanMonthToasterMessage".localized)
                return false
            }
        }
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            firstDate = nil
            calendarView.deselectAllDates(triggerSelectionDelegate: false)
            return false
        }
        return true
    }
    
}



