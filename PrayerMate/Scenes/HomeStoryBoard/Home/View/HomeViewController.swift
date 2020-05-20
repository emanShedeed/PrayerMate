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
final class HomeViewController: BaseViewController {
    
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
    var presenter:HomePresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    var backGroundImagesArray = [UIImage.fajrBackGround,UIImage.sunriseBackGround,UIImage.zuhrBackGround,UIImage.asrBackGround,UIImage.maghribBackGround,UIImage.ishaBackGround]
    var getNextDayTimes = false
    ////Calendar VARiIABLES
    let calendareFormatter = DateFormatter()
    var firstDate: Date?
    var secondDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    ///
    var selectedPrayerTimesIndicies: [Int] = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        presenter.requestPrayerTimesAPI()
        
        presenter.setupCalendarView(calendarView: calendarView, calenadrIncludingHeaderView: calenadrIncludingHeaderView, calendareFormatter: calendareFormatter)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        hideCalendareView.addGestureRecognizer(tap)
        
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
        presenter = HomePresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"
        
        prayerTimestableView.backgroundColor = UIColor.clear
        dateLBL.text = presenter.formateTodayDate()
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
            firstDate = nil
            secondDate = nil
            calendarView.deselectAllDates()
            calendarView.reloadData()
            calenadrIncludingHeaderView.isHidden=false
        }
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if let viewController = UIStoryboard.Settings.instantiateInitialViewController() as? UINavigationController {
            let settingsVC = viewController.viewControllers[0] as? SettingViewController
            settingsVC?.delegateToHome = self
            self.show(viewController, sender: self)
        }
    }
    
    @IBAction func calendarDoneBtnPressed(_ sender: Any) {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        
        if(self.firstDate == nil ){
            Helper.showToast(message: "Home.chooseDateRangeToasterMessage".localized)
            return
        }else{
            if(self.secondDate == nil){
                self.secondDate = self.firstDate
            }
            self.calenadrIncludingHeaderView.isHidden = true
            self.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.presenter.importPrayerTimesToSelectedCalendars(importStartDateAsString: formatter.string(from:self.firstDate ?? Date()), importEndDateAsString: formatter.string(from:self.secondDate ?? Date()),activityIndicator: self.activityIndicator)
                UserDefaults.standard.set(self.secondDate, forKey:UserDefaultsConstants.lastImportDate)
//                let _ = LocalNotification()
            }
            prayerTimesArray=[(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false)]
            self.prayerTimestableView.reloadData()
        }
    }
    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "PrayerTimeCell", for: indexPath)as! HomePrayerTimeCell
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
        self.selectedPrayerTimesIndicies = self.prayerTimesArray.indices.filter{self.prayerTimesArray[$0].isBtnChecked == true}
        UserDefaults.standard.set(self.selectedPrayerTimesIndicies, forKey: UserDefaultsConstants.selectedPrayerTimesIndicies)
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
      
        if(getNextDayTimes){
            presenter.requestPrayerTimesAPI()
            getNextDayTimes = false
        }
        for  i in 0..<presenter.todayParyerTimes.count {
            accurateString = presenter.getPrayerTimeAccurateString(time: presenter.todayParyerTimes[i])
            let dateAsString = countDownTimerFormatter.string(from: Date())
            if(i == 0 ){
                let diff = Helper.findDateDiff(time1Str: presenter.getPrayerTimeAccurateString(time: presenter.todayParyerTimes[5]), time2Str: dateAsString, isNextDayFajr: IsfajrOfNextDate)
                if(!diff.contains("-") ){
                    IsfajrOfNextDate = true
                    getNextDayTimes = true
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
    
}
/// This is a class created for handling JTAppleCalendar dataSource functions
extension HomeViewController:JTACMonthViewDataSource{
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Date()
        var endDate = Date()
        // Get the current year
        let year = Calendar.current.component(.year, from: Date())
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            endDate = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear) ?? Date()
        }
        //        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, calendar: Calendar(identifier: .gregorian), generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday)
        return parameters
    }
}
/// This is a class created for handling JTAppleCalendar delegate functions
extension HomeViewController:JTACMonthViewDelegate{
    //Display the Cell
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomJTAppleCalendarCell
     configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell=calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomJTAppleCalendarCell", for: indexPath) as! CustomJTAppleCalendarCell
        cell.dayLabel.text = cellState.text
      handelCellSelectedColor(cell: cell, celssState: cellState)
      configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if firstDate != nil {
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            secondDate = date
        } else {
            firstDate = date
        }
        configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
       configureCell(view: cell, cellState: cellState, calendareFormatter: calendareFormatter)
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
        
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && ( date <= (calendarView.selectedDates.count > 0 ? calendarView.selectedDates[0] : date)) {
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
extension HomeViewController{
    func configureCell(view: JTACDayCell?, cellState: CellState,calendareFormatter:DateFormatter) {
          guard let cell = view as? CustomJTAppleCalendarCell  else { return }
          cell.dayLabel.text = cellState.text
          handleCellTextColor(cell: cell, cellState: cellState,calendareFormatter:calendareFormatter)
          handleCellSelected(cell: cell, cellState: cellState)
      }
    func handelCellSelectedColor(cell:JTACDayCell?,celssState:CellState){
        guard let validCell = cell as? CustomJTAppleCalendarCell else{return}
        if(validCell.isSelected){
            validCell.selectedView.isHidden=false
        }else{
            validCell.selectedView.isHidden=true
        }
    }
    
    func handleCellTextColor(cell:JTACDayCell?,cellState:CellState,calendareFormatter:DateFormatter){
        guard let validCell = cell as? CustomJTAppleCalendarCell else{return}
        if(validCell.isSelected){
            validCell.dayLabel.textColor = UIColor.appColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dayLabel.textColor = .black
            }else{
                validCell.dayLabel.textColor = UIColor.dayCellGrayTextColor
            }
        }
        let currentDateAsString=calendareFormatter.string(from: Date())
        let cellDateAsString=calendareFormatter.string(from: cellState.date)
        if(calendareFormatter.date(from: cellDateAsString)! < calendareFormatter.date(from: currentDateAsString)!){
            //  Helper.showToast(message: "can't select date before today")
            validCell.dayLabel.textColor = UIColor(rgb:0xDEE3E7)
        }
    }
    
    func handleCellSelected(cell: CustomJTAppleCalendarCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            //              cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            //              cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
        case .right:
            //              cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            //              cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }
    }
    
  
}



