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
    
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var selectedPrayerTimeName: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var calendarDateTitleLbl: UILabel!
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var calenadrIncludingHeaderView: UIView!
    
    let formatter = DateFormatter()
    var dateAsString = ""
    let calendar = Calendar.current
    var futureDate: Date!
    var currentTime:String = ""
    var countdown: DateComponents!
    
    var addressTitle : String!
    var presenter:HomeVCPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    ////Calendar
    let calendareFormatter = DateFormatter()
    let testCalendar = Calendar(identifier: .gregorian)
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        formatter.dateFormat = "hh:mm:ss a"
        dateAsString = formatter.string(from: Date())
        
        presenter = HomeVCPresenter(view: self)
        //        prayerTimesArray=[(isCellSelected: Bool,Bool)]
        prayerTimestableView.backgroundColor = UIColor.clear
        importBtn.addBlurEffect()
        formateDate()
        let urlString="https://muslimsalat.com/" + addressTitle + "/yearly/22-03-2020/false/1.json?key=48ae8106ef6b55e5dac258c0c8d2e224"
        
        let ecnodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: ecnodingString ?? "")
        if let final_url = url{
            presenter.dataRequest(FINAL_URL:final_url)
        }
        setupCalendarView()
        
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
                formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
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
extension HomeVC{
    @objc func updateTime() {
        dateAsString = formatter.string(from: Date())
        self.countdown = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: formatter.date(from: dateAsString) ?? Date() , to: self.futureDate)
        //only compute once per call
        //       let days = countdown1.day!
        let hours = countdown.hour!
        let minutes = countdown.minute!
        let seconds = countdown.second!
        print( String(format: "%02d:%02d:%02d",  hours, minutes, seconds))
        //        if(AppSetting.shared.getCurrentLanguage() == .ar){
        //            remainingTimeLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds).EnToARDigits
        //        }else{
        remainingTimeLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        //        }
        
    }
    
    func runCountdown() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}
extension HomeVC:JTACMonthViewDataSource{
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let startDate = Date()
        //        let endDate = Date()
        //        let startDate=calendarFormatter.date(from: "2020 03 24")!
        //        let endDate=calendarFormatter.date(from: "2020 04 24")!
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        //        let parameters = ConfigurationParameters(startDate:startDate , endDate:endDate)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, generateInDates: .off, generateOutDates: .off , firstDayOfWeek: .sunday)
        return parameters
    }
}
extension HomeVC:JTACMonthViewDelegate{
    //Display the Cell
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomJTAppleCalendarCell
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell=calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomJTAppleCalendarCell", for: indexPath) as! CustomJTAppleCalendarCell
        cell.dayLabel.text = cellState.text
        handelCellSelectedColor(cell: cell, celssState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if firstDate != nil {
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool{
        let dateAsString = calendareFormatter.string(from: date)
        let currentDateAsString=calendareFormatter.string(from: Date())
        if(calendareFormatter.date(from: dateAsString)! < calendareFormatter.date(from: currentDateAsString)!){
            return false
        }
//        if(firstDate != nil){
//            let firstDateAsString = calendareFormatter.string(from: firstDate!)
//            let MaxDate =  Calendar.current.date(byAdding: .month, value: 1, to: calendareFormatter.date(from: firstDateAsString)!) ?? Date()
//            let maxDateAsString = calendareFormatter.string(from: MaxDate)
//            if(calendareFormatter.date(from: dateAsString)! > calendareFormatter.date(from: maxDateAsString)!){
//               
//                return false
//            }
//        }
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
            firstDate = nil
            let retval = !calendarView.selectedDates.contains(date)
            calendarView.deselectAllDates(triggerSelectionDelegate: false)
            return retval
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


extension HomeVC{
    func setupCalendarView(){
        //
        calendareFormatter.dateFormat="yyyy MM dd"
        calendareFormatter.timeZone = Calendar.current.timeZone
        calendareFormatter.locale = Calendar.current.locale
        calendarView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        //make top rounded calendar
        calenadrIncludingHeaderView.roundCorners([.topLeft,.topRight], radius: 20)
        //setup calendarSpacing
        calendarView.minimumLineSpacing=0
        calendarView.minimumInteritemSpacing=0
        //setup header Date Label
        
        calendarView.visibleDates { (visableDates) in
            self.setupViewsOfCalendar(from: visableDates)
        }
    }
    func setupViewsOfCalendar(from visibleDates:DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat="yyyy"
        let year=formatter.string(from: date)
        formatter.dateFormat="MMMM"
        let month=formatter.string(from: date)
        calendarDateTitleLbl.text = month + " " + year
    }
    func handelCellSelectedColor(cell:JTACDayCell?,celssState:CellState){
        guard let validCell = cell as? CustomJTAppleCalendarCell else{return}
        if(validCell.isSelected){
            validCell.selectedView.isHidden=false
        }else{
            validCell.selectedView.isHidden=true
        }
    }
    func handleCellTextColor(cell:JTACDayCell?,cellState:CellState){
        guard let validCell = cell as? CustomJTAppleCalendarCell else{return}
        if(validCell.isSelected){
            validCell.dayLabel.textColor = .black
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dayLabel.textColor = .black
            }else{
                validCell.dayLabel.textColor = UIColor(rgb:0xDEE3E7)
            }
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
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CustomJTAppleCalendarCell  else { return }
        cell.dayLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
}


