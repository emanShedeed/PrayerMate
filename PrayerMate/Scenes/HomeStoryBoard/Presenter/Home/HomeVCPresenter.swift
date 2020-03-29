//
//  HomeVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import JTAppleCalendar
protocol  HomeView :class{
    func showError(error:String)
    func fetchDataSucess()

}
protocol PrayerTimeCellView {
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int)
}
/// This is a presenter class created for handling MovesHomeVC Functions.
class HomeVCPresenter{
    private weak var view : HomeView?
    init(view:HomeView) {
        self.view=view
    }
    let prayerTimesNames=["Home.fajrPrayerLblTitle","Home.sunrisePrayerLblTitle","Home.zuhrPrayerLblTitle","Home.asrPrayerLblTitle","Home.maghribPrayerLblTitle","Home.ishaPrayerLblTitle"]
    var todayParyerTimes = [String]()

    var calendarDateTitle = ""
    func ConfigureCell(cell:PrayerTimeCellView,isCellSelected:Bool,isChecked:Bool,cellIndex:Int){
         
        cell.displayData(prayerTimeName: prayerTimesNames[cellIndex].localized, prayerTime: todayParyerTimes[cellIndex] ?? "", isCellSelected:isCellSelected,isBtnChecked:isChecked,cellIndex:cellIndex)
          
      }
      func dataRequest (FINAL_URL : URL) {
            
         if Helper.isConnectedToNetwork(){
                
                let task = URLSession.shared.dataTask(with: FINAL_URL){
                    (data,response,error) in
                    
                    if let URLresponse = response {
                        print(URLresponse)
                    }
                    if let URLerror = error {
                        print(URLerror)
                    }
                    if let URLdata = data {
                        print(URLdata)
                        do{
                            let prayerTimes = try JSONDecoder().decode(PrayerTimes.self, from: URLdata)
                            if(prayerTimes.statusValid == 1){
//                            print(prayerTimes.items?[0].dateFor)
                            self.todayParyerTimes=[(prayerTimes.items?[0].fajr ?? ""),(prayerTimes.items?[0].shurooq ?? ""),(prayerTimes.items?[0].dhuhr ?? ""),(prayerTimes.items?[0].asr ?? ""),(prayerTimes.items?[0].maghrib ?? ""),(prayerTimes.items?[0].isha ?? "")]
                            self.view?.fetchDataSucess()
                            }else{
                                self.view?.showError(error: prayerTimes.statusDescription ?? "can't get data")
                            }
                          
                        }catch {
                            print("Error: \(error)")
                        }
    //                    self.PRAYER_DATA_HANDLEROB = PrayerTimeHandler.init(_data: URLdata)
    //                    self.PRAYER_DATA_HANDLEROB.decodeData()
    //
    //                    let delay = DispatchTime.now() + 1
    //                    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
    //                        self.wayToDisplayData()
    //                    })
                        
                    }
                }
                
                task.resume()
                
            }else{
            self.view?.showError(error: "Please check your internet connection")
            }
        }
    func formateTodayDate() -> String {
        // formate as March 23, 2018
        let formatter = DateFormatter()
         let outputDate = ""
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
            return outputDate
        }
        return outputDate
    }
}
extension HomeVCPresenter{
    func setupCalendarView(calendarView:JTACMonthView,calenadrIncludingHeaderView:UIView,calendareFormatter:DateFormatter){
        //
      
        calendareFormatter.dateFormat="yyyy MM dd"
        calendareFormatter.timeZone = Calendar.current.timeZone
        calendareFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        calendarView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        //make top rounded calendar
        calenadrIncludingHeaderView.roundCorners([.topLeft,.topRight], radius: 20)
        //setup calendarSpacing
        calendarView.minimumLineSpacing=0
        calendarView.minimumInteritemSpacing=0
        //setup header Date Label
        
        calendarView.visibleDates { (visableDates)  in
         self.setupViewsOfCalendar(from: visableDates)
        }
      
    }
    func setupViewsOfCalendar(from visibleDates:DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        let calenderTitleFormatter = DateFormatter()
        calenderTitleFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
        calenderTitleFormatter.dateFormat="yyyy"
        let year=calenderTitleFormatter.string(from: date)
        calenderTitleFormatter.dateFormat="MMMM"
        let month=calenderTitleFormatter.string(from: date)
        calendarDateTitle = month + " " + year
       // return (month + " " + year)
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
            validCell.dayLabel.textColor = .black
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dayLabel.textColor = .black
            }else{
                validCell.dayLabel.textColor = UIColor(rgb:0xDEE3E7)
            }
        }
        let currentDateAsString=calendareFormatter.string(from: Date())
//        if(AppSetting.shared.getCurrentLanguage() == .ar){
//
//            let dateFormatter = DateFormatter()
//
//             dateFormatter.dateFormat = "dd-MM-yyyy"
//
//            dateFormatter.locale = NSLocale(localeIdentifier: "ar_SA") as Locale
//
//            let islamicDate = dateFormatter.date(from: "8-10-1437")
//
//            let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
//
//            let components = gregorian?.components(NSCalendar.Unit(rawValue: UInt.max), from: islamicDate!)
//            print("\(components!.year) - \(components!.month) - \(components!.day)")
//        }
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
    func configureCell(view: JTACDayCell?, cellState: CellState,calendareFormatter:DateFormatter) {
        guard let cell = view as? CustomJTAppleCalendarCell  else { return }
        cell.dayLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState,calendareFormatter:calendareFormatter)
        handleCellSelected(cell: cell, cellState: cellState)
    }
}
