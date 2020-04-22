//
//  HomeVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import JTAppleCalendar
import RealmSwift
//Apple
import EventKit
//Microsoft
import MSGraphClientSDK
import MSGraphClientModels
//Google
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

protocol  HomeView :class{
    func showError(error:String)
    func fetchDataSucess()
    
}
protocol PrayerTimeCellView {
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int)
}
/// This is a presenter class created for handling HomeVC Functions.
class HomeVCPresenter{
    //MARK:VARiIABLES
    private weak var view : HomeView?
    init(view:HomeView) {
        self.view=view
    }
    let prayerTimesNames=["Home.fajrPrayerLblTitle","Home.sunrisePrayerLblTitle","Home.zuhrPrayerLblTitle","Home.asrPrayerLblTitle","Home.maghribPrayerLblTitle","Home.ishaPrayerLblTitle"]
    var todayParyerTimes = [String]()
    var annualPrayerTimes : HomeAPIResponseModel?
    
    var calendarDateTitle = ""
    //MARK:- Methods
    
    /**
     Call this function to configure each cell at Home VC.
     
     ### Usage Example: ###
     ````
     presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row].isCellSelected,isChecked:prayerTimesArray[indexPath.row].isBtnChecked,cellIndex:indexPath.row)
     ````
     - Parameters:
     - cell : the cell to be configured.
     - isCellSelected : is this cell Selected or Not.
     - isChecked : is the radio button at the cell is Checked or Not.
     - cellIndex : the Cell Index At tableView.
     */
    func ConfigureCell(cell:PrayerTimeCellView,isCellSelected:Bool,isChecked:Bool,cellIndex:Int){
        
        cell.displayData(prayerTimeName: prayerTimesNames[cellIndex].localized, prayerTime: todayParyerTimes[cellIndex] , isCellSelected:isCellSelected,isBtnChecked:isChecked,cellIndex:cellIndex)
        
    }
    func getPrayerTimeAccurateString(time : String) -> String{
        var accurateString :String = ""
        accurateString = time.count == 7 ? "0" + time : time
        accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
        accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
        accurateString = accurateString.replacingOccurrences(of: " ", with: ":00 ")
        return accurateString
    }
    /**
     Call this function to call the API.
     
     ### Usage Example: ###
     ````
     presenter.dataRequest(FINAL_URL:final_url)
     ````
     - Parameters:
     - FINAL_URL : the API URL.
     
     */
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
                        let prayerTimes = try JSONDecoder().decode(HomeAPIResponseModel.self, from: URLdata)
                        if(prayerTimes.statusValid == 1){
                            //                            print(prayerTimes.items?[0].dateFor)
                            self.todayParyerTimes=[(prayerTimes.items?[0].fajr ?? ""),(prayerTimes.items?[0].shurooq ?? ""),(prayerTimes.items?[0].dhuhr ?? ""),(prayerTimes.items?[0].asr ?? ""),(prayerTimes.items?[0].maghrib ?? ""),(prayerTimes.items?[0].isha ?? "")]
                            self.annualPrayerTimes = prayerTimes
                            self.view?.fetchDataSucess()
                        }else{
                            self.view?.showError(error: prayerTimes.statusError?.invalidQuery ?? "can't get data")
                        }
                        
                    }catch {
                        print("Error: \(error)")
                        self.view?.showError(error: "\(error)")
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
            self.view?.showError(error: "internetFailMessage".localized)
        }
    }
    
    /**
     Call this function to save Data To Realm.
     
     ### Usage Example: ###
     ````
     self.presenter.saveDataToRealm()
     ````
     - Parameters:
     
     
     */
    func saveDataToRealm(){
        var realm : Realm!
        do{
            realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
        }catch{
            print("Error intialize Realm \(error)")
        }
        
        annualPrayerTimes?.items?.forEach { (item) in
            let prayerTimeObject = RealmPrayerTimeModel()
            prayerTimeObject.id = prayerTimeObject.incrementID()
            prayerTimeObject.date = item.dateFor ?? ""
            prayerTimeObject.fajr = item.fajr ?? ""
            prayerTimeObject.shurooq = item.shurooq ?? ""
            prayerTimeObject.dhuhr = item.dhuhr ?? ""
            prayerTimeObject.asr = item.asr ?? ""
            prayerTimeObject.maghrib = item.maghrib ?? ""
            prayerTimeObject.isha = item.isha ?? ""
            do{
                try realm.write{
                    realm.add(prayerTimeObject)
                }
            }catch{
                print("Error intialize Real \(error)")
            }
            
        }
        print(realm.configuration.fileURL ?? "")
    }
    
    
    
    /**
     Call this function to formate today date to display at Home vc date label.
     
     ### Usage Example: ###
     ````
     dateLBL.text = presenter.formateTodayDate()
     ````
     - Parameters:
     
     
     */
    
    func formateTodayDate() -> String {
        // formate as March 23, 2018
        let formatter = DateFormatter()
        // set locale to "ar_DZ" and format as per your specifications
        if AppSetting.shared.getCurrentLanguage() == AppLanguages.ar{
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }else{
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        let outputDate = ""
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        // read input date string as NSDate instance
        if let date = formatter.date(from: myString) {
            
            
            formatter.dateFormat = "MMMM dd, yyyy "
            let outputDate = formatter.string(from: date)
            
            print(outputDate)
            return outputDate
        }
        return outputDate
    }
}
/// This is a presenter class created for handling HomeVC JTAppleCalendar helper Functions.
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
/// This is a presenter class created for handling importing prayerTimes To different Calendars
extension HomeVCPresenter{

        /**
         Call this function to import PrayerTimes To SelectedCalendars.
         
         ### Usage Example: ###
         ````
         self.presenter.importPrayerTimesToSelectedCalendars()
         ````
         - Parameters:
         
         
         */
        func importPrayerTimesToSelectedCalendars(importStartDateAsString:String , importEndDateAsString:String){
            let realm = try! Realm()
            
            let AppleDateFormatter = DateFormatter()
            AppleDateFormatter.dateFormat = "yyyy-M-d"
            AppleDateFormatter.timeZone =  TimeZone(secondsFromGMT: 0)
            
            let diffInDays = Calendar.current.dateComponents([.day], from: AppleDateFormatter.date(from: importStartDateAsString) ?? Date(), to: AppleDateFormatter.date(from: importEndDateAsString) ?? Date()).day
            
            // Query using an NSPredicate to get the id of object that have the same start date
            let predicate = NSPredicate(format: "date = %@ ", importStartDateAsString)
            let firstImportDateObjFromRealm = realm.objects(RealmPrayerTimeModel.self).filter(predicate).first
            //        print("\(equivalentDataFromeRealm?.date) with id \(equivalentDataFromeRealm?.id)")
            
            
    //        // Query using an NSPredicate to get all objects betwwen start and end date
    //        var pericateToGetAllObjects:NSPredicate!
    //        var objects: Results<RealmPrayerTimeModel>?
    //        if let id = equivalentDataFromeRealm?.id{
    //            pericateToGetAllObjects = NSPredicate(format: "id BETWEEN { %ld,  %ld}",id,Int(id + (diffInDays ?? 0)))
    //            objects = realm.objects(RealmPrayerTimeModel.self).filter(pericateToGetAllObjects)
    //        }
            
            ///get prayer buffer
            let fetchedData = UserDefaults.standard.data(forKey: "prayerTimesBufferArray")!
            let  prayerTimesBufferArray = try! PropertyListDecoder().decode([PrayerTimeBuffer].self, from: fetchedData)
            
            
            let calendars = UserDefaults.standard.value(forKey: "choosenCalendars") as? [Int]
            // get selected prayer times indicies
            let selectedPrayerTimesIndicies = UserDefaults.standard.value(forKey: "selectedPrayerTimesIndicies") as? [Int]
            //Import To Apple Calendar
        
                let calendar = Calendar.current
                let eventFormatter = DateFormatter()
                eventFormatter.dateFormat="yyyy-M-dd hh:mm:ss a"
            eventFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
    //            formatter.timeZone =  TimeZone(secondsFromGMT: 0)
                //
            let MSFormatter = DateFormatter()//"2020-03-03T9:00:00"
            MSFormatter.dateFormat="yyyy-MM-dd hh:mm a"
            MSFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
        
      //
            let googleFormatter = DateFormatter()//"2020-03-03T9:00:00"
                   googleFormatter.dateFormat="dd/MM/yyyy HH:mm"
                   googleFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
            ///
                var eventStartDate:Date?
                var eventEndDate:Date?
    //            objects?.forEach({ (day) in
            if let obj = firstImportDateObjFromRealm{
            
                    selectedPrayerTimesIndicies?.forEach({ (index) in
                        
                        let timeBefore = prayerTimesBufferArray[index].before
                        let timeAfter =  prayerTimesBufferArray[index].after
                        let type =  prayerTimesBufferArray[index].type
                        ////
                        var prayerTime = ""
                        var prayerName = ""
                        if(index == 0){
                            prayerTime = obj.fajr
                            prayerName = "Fajr"
                        }else if(index == 1){
                            prayerTime = obj.shurooq
                                prayerName = "Sunrise"
                        }else if(index == 2){
                            prayerTime = obj.dhuhr
                              prayerName = "Zuhr"
                        }else if(index == 3){
                            prayerTime = obj.asr
                                 prayerName = "Asr"
                        }else if(index == 4){
                            prayerTime = obj.maghrib
                                 prayerName = "Maghrib"
                        }else if(index == 5){
                            prayerTime = obj.isha
                             prayerName = "ISha"
                        }
                        let eventDate = obj.date + " " +
                            getPrayerTimeAccurateString(time:prayerTime)
                        let date = eventFormatter.date(from: eventDate) ?? Date()
                        if(type == "M"){
                            eventStartDate = calendar.date(byAdding: .minute, value: (-1 * timeBefore), to: date)
                            eventEndDate = calendar.date(byAdding: .minute, value: timeAfter, to: date)
    //                        print("\(eventStartDate), \(eventEndDate)")
                        }else if(type == "H"){
                            eventStartDate = calendar.date(byAdding: .hour, value: (-1 * timeBefore), to: date)
                            eventEndDate = calendar.date(byAdding: .hour, value: timeAfter, to: date)
    //                        print("\(eventStartDate), \(eventEndDate)")
                        }
                        if(calendars?.contains(0) ?? false){
                            self.addEventListToAppleCalendar(title: "it's \(prayerName) time", description: "", eventStartDate: eventStartDate ?? Date(), eventEndDate: eventEndDate ?? Date(), tillDate: AppleDateFormatter.date(from: importEndDateAsString) ?? Date())
                            sleep(1)
                        }
                        if(calendars?.contains(1) ?? false){
                            let decoded  =  UserDefaults.standard.data(forKey: "googleService")
                                let decodedservice = NSKeyedUnarchiver.unarchiveObject(with: decoded! ) as! GoogleService
                            self.addEventListToGoogleCalendar(title: "it's \(prayerName) time", description: "", eventStartDate:googleFormatter.string(from: eventStartDate ?? Date()), eventEndDate: googleFormatter.string(from: eventEndDate ?? Date()) , tillDate: importEndDateAsString)
                            sleep(1)
                        }
                        if(calendars?.contains(2) ?? false){
                            
                           let id = UserDefaults.standard.value(forKey: "microsoftCalendarID") as! String
                            
                            self.addEventListToMicrosoftCalendar(calendarId:id , title: "it's \(prayerName) time", description: "", eventStartDate:MSFormatter.string(from: eventStartDate ?? Date()), eventEndDate: MSFormatter.string(from: eventEndDate ?? Date()) , tillDate: importEndDateAsString)
                            sleep(1)
                        }
                        
                    })
            }
                    
    //            })
                

        }
        //Apple
        /**
         Call this function to import PrayerTimes To Apple Calendar.
         
         ### Usage Example: ###
         ````
         self.presenter.importPrayerTimesToSelectedCalendars()
         ````
         - Parameters:
         
         
         */
         func addEventListToAppleCalendar(title: String, description: String?, eventStartDate: Date, eventEndDate: Date,tillDate:Date){
                let eventStore : EKEventStore = EKEventStore()
            let repeatTillDate = Calendar.current.date(byAdding: .day, value: 1, to: tillDate) ?? Date()

                // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
                
                eventStore.requestAccess(to: .event) { (granted, error) in
                    
                    if (granted) && (error == nil) {
                        print("granted \(granted)")
                        print("error \(String(describing: error))")
                        
                        var event:EKEvent = EKEvent(eventStore: eventStore)
        //                for index in 1...5 {
                            event = EKEvent(eventStore: eventStore)
                            event.title = title
                            event.startDate = eventStartDate
                            event.endDate = eventEndDate
                            event.notes = description
                            event.calendar = eventStore.defaultCalendarForNewEvents
                      
                        let recurrenceRule = EKRecurrenceRule.init(
                                         recurrenceWith: .daily,
                                         interval: 1,
                                         daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday),EKRecurrenceDayOfWeek.init(EKWeekday.sunday),EKRecurrenceDayOfWeek.init(EKWeekday.monday),EKRecurrenceDayOfWeek.init(EKWeekday.tuesday),EKRecurrenceDayOfWeek.init(EKWeekday.wednesday),EKRecurrenceDayOfWeek.init(EKWeekday.thursday),EKRecurrenceDayOfWeek.init(EKWeekday.friday)],
                                         daysOfTheMonth: nil,
                                         monthsOfTheYear: nil,
                                         weeksOfTheYear: nil,
                                         daysOfTheYear: nil,
                                         setPositions: nil,
                                         end: EKRecurrenceEnd.init(end:repeatTillDate)
                                     )

                                     event.recurrenceRules = [recurrenceRule]
                            do {
                                try eventStore.save(event, span: .thisEvent)
                            } catch let error as NSError {
                                print("failed to save event with error : \(error)")
                            }
                            print("Saved Event")
        //                }
                    }
                    else{
                        
                        print("failed to save event with error : \(String(describing: error)) or access not granted")
                    }
                }
            }
        ///
      
        func  addEventListToMicrosoftCalendar(calendarId:String,title: String, description: String?, eventStartDate: String, eventEndDate: String,tillDate:String){
            let token = UserDefaults.standard.value(forKey: "microsoftAuthorization") as! String
            let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)
            let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
            var urlRequest: NSMutableURLRequest? = nil
            if let url = URL(string: MSGraphBaseURL + ("me/calendars/" + "\(calendarId)" + "/events")) {
                urlRequest = NSMutableURLRequest(url: url)
            }
            urlRequest?.httpMethod = "POST"
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let event2 = ["subject":title , "body":["contentType" : "text"],"start" :["dateTime":eventStartDate , "timeZone":"UTC"],"end" :["dateTime":eventEndDate , "timeZone":"UTC"],"recurrence":["pattern":["type":"daily","interval":"1"],"range":["type":"endDate","startDate":eventStartDate.split(separator: " ").first ?? "","endDate":tillDate]]] as [String : Any]
            do{
                      let eventData = try JSONSerialization.data(withJSONObject: event2, options: .prettyPrinted)
                      print(eventData)
                      urlRequest?.httpBody = eventData
                  }
                  catch {
                      print(error)
                  }

           var meDataTask: MSURLSessionDataTask? = nil
            if let urlRequest = urlRequest {
                       meDataTask = httpClient?.dataTask(with: urlRequest, completionHandler: { data, response, nserror in
                           //Request Completed
                        if let returneddata = data {
                                print(returneddata)
                                    }
                           print("event added")
                           
                       })
                   }

            meDataTask?.execute()
                 
             }
        
        func  addEventListToGoogleCalendar(title: String, description: String?, eventStartDate: String, eventEndDate: String,tillDate:String){
                 let calendarEvent = GTLRCalendar_Event()
                       calendarEvent.summary = title
                       calendarEvent.descriptionProperty = description
                       
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                       let startDate = dateFormatter.date(from: eventStartDate)
                       let endDate = dateFormatter.date(from: eventEndDate)
                       
                       guard let toBuildDateStart = startDate else {
                           print("Error getting start date")
                           return
                       }
                       guard let toBuildDateEnd = endDate else {
                           print("Error getting end date")
                           return
                       }
                       calendarEvent.start = buildDate(date: toBuildDateStart)
                       calendarEvent.end = buildDate(date: toBuildDateEnd)
                      
                       let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
                        calendarEvent.recurrence = ["RRULE:FREQ=DAILY;UNTIL=20200428"]
            let decoded  =  UserDefaults.standard.data(forKey: "googleService")
            let decodedservice = NSKeyedUnarchiver.unarchiveObject(with: decoded! ) as! GoogleService
         
            decodedservice.executeQuery(insertQuery) { (ticket, object, error) in
                           if error == nil {
                               print("Event inserted")
                           } else {
                               print(error)
                           }
                       }
        }
        // Helper to build date
              func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
                  let timeZone = NSTimeZone.system
                  let datetime = GTLRDateTime(date: date)
                  let dateObject = GTLRCalendar_EventDateTime()
                  dateObject.dateTime = datetime
                  dateObject.timeZone=timeZone.identifier
                  return dateObject
              }
}
