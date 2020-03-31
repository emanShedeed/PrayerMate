//
//  HomeVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import JTAppleCalendar
class HomeVC: UIViewController {
    
  //MARK:- IBOUTLET
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

    var addressTitle : String!
    var presenter:HomeVCPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    ////Calendar VARiIABLES
    let calendareFormatter = DateFormatter()
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        calendarView.semanticContentAttribute = .forceRightToLeft
         daysStackView.semanticContentAttribute = .forceLeftToRight
        presenter = HomeVCPresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"
        
        prayerTimestableView.backgroundColor = UIColor.clear
        importBtn.addBlurEffect()
        dateLBL.text = presenter.formateTodayDate()
        addressTitle = UserDefaults.standard.value(forKey: "addressTitle") as? String ?? ""
        let urlString="https://muslimsalat.com/" +  addressTitle + "/yearly/22-03-2020/false/1.json?key=48ae8106ef6b55e5dac258c0c8d2e224"
        print(urlString)
        let ecnodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: ecnodingString ?? "")
        if let final_url = url{
            presenter.dataRequest(FINAL_URL:final_url)
        }
        presenter.setupCalendarView(calendarView: calendarView, calenadrIncludingHeaderView: calenadrIncludingHeaderView, calendareFormatter: calendareFormatter)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
         hideCalendareView.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        calenadrIncludingHeaderView.isHidden = true
    }
    
    @IBAction func importBtnPressed(_ sender: Any) {
        calenadrIncludingHeaderView.isHidden=false
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if let viewController = UIStoryboard.Settings.instantiateInitialViewController(){
        self.show(viewController, sender: self)
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
extension HomeVC{
    @objc func updateTime() {
        let dateAsString = countDownTimerFormatter.string(from: Date())
        self.countdown = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: countDownTimerFormatter.date(from: dateAsString) ?? Date() , to: self.nextPrayerDateDate)
        let hours = countdown.hour!
        let minutes = countdown.minute!
        let seconds = countdown.second!
        print( String(format: "%02d:%02d:%02d",  hours, minutes, seconds))
        remainingTimeLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
    }
    
    func runCountdown() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}
extension HomeVC:JTACMonthViewDataSource{
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, calendar: Calendar(identifier: .gregorian), generateInDates: .off, generateOutDates: .off, firstDayOfWeek: .sunday)
        return parameters
    }
}
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



