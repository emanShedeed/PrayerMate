//
//  ExportingViewController.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/4/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
import JTAppleCalendar
class ExportingViewController: BaseViewController {
    
    
    //MARK:- IBOUTLET
    
    
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    //// Calendar IBOUTLET
    @IBOutlet weak var calendarDateTitleLbl: UILabel!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var calenadrIncludingHeaderView: UIView!
    @IBOutlet weak var hideCalendareView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    
    @IBOutlet weak var closeCalendarViewBtn: UIButton!
    //MARK:VARiIABLES
    let titleLabel=UILabel()
    let countDownTimerFormatter = DateFormatter()
    var countdown: DateComponents!
    let calendar = Calendar.current
    var nextPrayerDateDate: Date!
    var numberOfSelectedPrayerTimes : Int = 0
    var presenter:ExportingPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    
    //    var getNextDayTimes = false
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
        setUpNavBar()
    calenadrIncludingHeaderView.roundCorners([.topLeft,.topRight], radius: 20)
        
        presenter.setupCalendarView(calendarView: calendarView, calendareFormatter: calendareFormatter)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        hideCalendareView.addGestureRecognizer(tap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         prayerTimesArray=[(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false),(isCellSelected:false,isBtnChecked:false)]
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        
          importBtn.applyGradient(with:  [UIColor.exportBtnG2!, UIColor.exportBtnG1!], gradient: .horizontal)
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
        presenter = ExportingPresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"

       styleNavBar()
//        prayerTimestableView.backgroundColor = UIColor.clear
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
//        shadowView.isHidden = true
    }
    
    func setUpNavBar(){
          styleNavBar()
          TransparentNavBar()
          let backButton = UIBarButtonItem()
          backButton.title = "ExportingVC.navigationBackButton".localized
          self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
          
//          let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.white]
//          titleLabel.attributedText = NSAttributedString(string: "FAQs.titleLbl".localized, attributes: attributes as [NSAttributedString.Key : Any])
//
//          titleLabel.letterSpace=1.08
//          titleLabel.sizeToFit()
//        navigationItem.titleView = titleLabel
    }
    //MARK:- IBActions
    @IBAction func closeCalendarViewBtnPressed(_ sender: Any) {
           calenadrIncludingHeaderView.isHidden = true
        closeCalendarViewBtn.isEnabled = false
        closeCalendarViewBtn.isHidden = true
      }
    @IBAction func importBtnPressed(_ sender: Any) {
        if(numberOfSelectedPrayerTimes > 0){
            firstDate = nil
            secondDate = nil
            calendarView.deselectAllDates()
             calendarDateTitleLbl.text = presenter.calendarDateTitle
            calendarView.reloadData()
            calenadrIncludingHeaderView.isHidden=false
            closeCalendarViewBtn.isEnabled = true
            closeCalendarViewBtn.isHidden = false
        }
    }
    
    @IBAction func automaticSelectPrayerTimeswichPressed(_ sender: UISwitch) {
        if(sender.isOn){
     prayerTimesArray = [(Bool,Bool)]( repeating: (true,true), count: 6 )
            numberOfSelectedPrayerTimes = 6
        }else{
          prayerTimesArray = [(Bool,Bool)]( repeating: (false,false), count: 6 )
            numberOfSelectedPrayerTimes = 0
        }
        saveSelectedPrayerTimesIndicies()
        prayerTimestableView.reloadData()
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
            closeCalendarViewBtn.isEnabled = false
            closeCalendarViewBtn.isHidden = true
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
    func saveSelectedPrayerTimesIndicies(){
        self.selectedPrayerTimesIndicies = self.prayerTimesArray.indices.filter{self.prayerTimesArray[$0].isBtnChecked == true}
        UserDefaults.standard.set(self.selectedPrayerTimesIndicies, forKey: UserDefaultsConstants.selectedPrayerTimesIndicies)
    }
    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension ExportingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ExportingPrayerTimeCell", for: indexPath)as! ExportingPrayerTimeCell
        presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row].isBtnChecked,isChecked:prayerTimesArray[indexPath.row].isBtnChecked,cellIndex:indexPath.row)
       numberOfSelectedPrayerTimes = prayerTimesArray[indexPath.row].isBtnChecked ? numberOfSelectedPrayerTimes + 1 : numberOfSelectedPrayerTimes
        cell.cellDelegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToRoomDetailsVC", sender: self)
//        numberOfSelectedPrayerTimes += 1
//        for index in 0 ..< prayerTimesArray.count {
//            prayerTimesArray[index].isCellSelected = false
//        }
        prayerTimesArray[indexPath.row].isCellSelected =  !(prayerTimesArray[indexPath.row].isCellSelected)
        
        prayerTimesArray[indexPath.row].isBtnChecked = !(prayerTimesArray[indexPath.row].isBtnChecked)
        
         
        
      saveSelectedPrayerTimesIndicies()
        prayerTimestableView.reloadData()
    }
    
    
    
}

/// This is a class created for handling JTAppleCalendar dataSource functions
extension ExportingViewController:JTACMonthViewDataSource{
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
extension ExportingViewController:JTACMonthViewDelegate{
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
extension ExportingViewController{
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

