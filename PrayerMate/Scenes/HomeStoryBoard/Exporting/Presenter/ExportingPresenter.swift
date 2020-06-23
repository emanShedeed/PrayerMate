//
//  ExportingPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/4/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
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

protocol  ExportingViewControllerProtocol :class {
    func showError(error:String)
    func showIndicator()
    func imoprtToCalendarsSuccess()
}
extension ExportingViewControllerProtocol{
    func showError(error:String){
        
    }
    func showIndicator(){
        
    }
}
protocol UpdateExportingPrayerTimeCellProtcol {
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int)
}
/// This is a presenter class created for handling HomeVC Functions.
class ExportingPresenter{
    
    //MARK:VARiIABLES
    var appleEvents = [EKEvent]()
    let eventStore : EKEventStore = EKEventStore()
    var event:EKEvent!
    var googleEvents = [EventData]()
    var microsoftEvents  = [EventData]()
    
    private weak var view : ExportingViewControllerProtocol?
    init(view:ExportingViewControllerProtocol) {
        self.view=view
        event = EKEvent(eventStore: eventStore)
    }
    let prayerTimesNames=["Home.fajrPrayerLblTitle","Home.sunrisePrayerLblTitle","Home.zuhrPrayerLblTitle","Home.asrPrayerLblTitle","Home.maghribPrayerLblTitle","Home.ishaPrayerLblTitle"]
    var todayParyerTimes = [String]()
    var annualPrayerTimes : [PrayerTimesResponseModel]?
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
    func ConfigureCell(cell:UpdateExportingPrayerTimeCellProtcol,isCellSelected:Bool,isChecked:Bool,cellIndex:Int){
        todayParyerTimes = (UserDefaults.standard.value(forKey: UserDefaultsConstants.todayParyerTimes) as! [String])
        cell.displayData(prayerTimeName: prayerTimesNames[cellIndex].localized, prayerTime: todayParyerTimes[cellIndex] , isCellSelected:isCellSelected,isBtnChecked:isChecked,cellIndex:cellIndex)
        
    }
    
    
    /**
     Call this function to get Prayer Time Accurate String as the string returned from the API like 3:4 am -> 3:04 AM .
     
     ### Usage Example: ###
     ````
     getPrayerTimeAccurateString(time:prayerTime)
     ````
     - Parameters:
     - time : prayer Time.
     */
    func getPrayerTimeAccurateString(time : String) -> String{
        var accurateString :String = ""
        accurateString = time.count == 7 ? "0" + time : time
        accurateString = accurateString.replacingOccurrences(of: "am", with: "AM")
        accurateString = accurateString.replacingOccurrences(of: "pm", with: "PM")
        accurateString = accurateString.replacingOccurrences(of: " ", with: ":00 ")
        return accurateString
    }
    
}

/// This is a presenter class created for handling importing prayerTimes To different Calendars
extension ExportingPresenter{
    
    /**
     Call this function to import PrayerTimes To SelectedCalendars.
     
     ### Usage Example: ###
     ````
     self.presenter.importPrayerTimesToSelectedCalendars()
     ````
     - Parameters:
     - importStartDateAsString : start date at string format.
     - importEndDateAsString : end date at string format.
     
     */
    func importPrayerTimesToSelectedCalendars(importStartDateAsString:String , importEndDateAsString:String){
        view?.showIndicator()
        UIApplication.shared.beginIgnoringInteractionEvents()
         appleEvents = [EKEvent]()
        googleEvents = [EventData]()
        microsoftEvents  = [EventData]()
        var numberOfcalenderThatImportData = 0
        let realm = try! Realm()
      
        var decoded :Data?
        var decodedservice:GoogleService?
        //
        let eventFormatter = DateFormatter()
        eventFormatter.dateFormat="yyyy-M-dd hh:mm:ss a"
        eventFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
        //
        let AppleDateFormatter = DateFormatter()
        AppleDateFormatter.dateFormat = "yyyy-M-d"
        AppleDateFormatter.timeZone =  TimeZone(secondsFromGMT: 0)
        
        //
        let MSFormatter = DateFormatter()//"2020-03-03T9:00:00"
        MSFormatter.dateFormat="yyyy-MM-dd hh:mm a"
        MSFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
        
        //
        let googleFormatter = DateFormatter()//"2020-03-03T9:00:00"
        googleFormatter.dateFormat="dd/MM/yyyy HH:mm"
        googleFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
        let googleTillDateFormatter = DateFormatter()
        googleTillDateFormatter.dateFormat="yyyy-MM-dd"
        googleTillDateFormatter.locale=NSLocale(localeIdentifier: "en") as Locale
        
        
        // Query using an NSPredicate to get the id of object that have the same start date
        let predicate = NSPredicate(format: "date = %@ ", importStartDateAsString)
        let firstImportDateObjFromRealm = realm.objects(RealmPrayerTimeModel.self).filter(predicate).first
        // Query using an NSPredicate to get all objects betwwen start and end date
        var pericateToGetAllObjects:NSPredicate!
        var objects: Results<RealmPrayerTimeModel>?
        let diffInDays = Calendar.current.dateComponents([.day], from: AppleDateFormatter.date(from: importStartDateAsString) ?? Date(), to: AppleDateFormatter.date(from: importEndDateAsString) ?? Date()).day
        if let id = firstImportDateObjFromRealm?.id{
            pericateToGetAllObjects = NSPredicate(format: "id BETWEEN { %ld,  %ld}",id,Int(id + (diffInDays ?? 0)))
            objects = realm.objects(RealmPrayerTimeModel.self).filter(pericateToGetAllObjects)
        }
        
        ///get prayer buffer
        let fetchedData = UserDefaults.standard.data(forKey: UserDefaultsConstants.prayerTimesBufferArray)!
        let  prayerTimesBufferArray = try! PropertyListDecoder().decode([PrayerTimeBuffer].self, from: fetchedData)
        
        //get selected calendars
        let calendars = UserDefaults.standard.value(forKey: UserDefaultsConstants.choosenCalendars) as? [Int]
        if(calendars?.contains(1) ?? false){
          decoded = UserDefaults.standard.data(forKey: UserDefaultsConstants.googleService)
            decodedservice = NSKeyedUnarchiver.unarchiveObject(with: decoded! ) as? GoogleService
                   
        }
        // get selected prayer times indicies
        let selectedPrayerTimesIndicies = UserDefaults.standard.value(forKey: UserDefaultsConstants.selectedPrayerTimesIndicies) as? [Int]
        
        
        
        let calendar = Calendar.current
        var eventStartDate:Date?
        var eventEndDate:Date?
        
        //        if let obj = firstImportDateObjFromRealm{
        let microsoftCalendarID = UserDefaults.standard.value(forKey: UserDefaultsConstants.microsoftCalendarID) as? String
        var googleEventObj : EventData!
        var microsoftEventObj : EventData!
        
        objects?.forEach({ (obj) in
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
                }else if(type == "H"){
                    eventStartDate = calendar.date(byAdding: .hour, value: (-1 * timeBefore), to: date)
                    eventEndDate = calendar.date(byAdding: .hour, value: timeAfter, to: date)
                    
                }
                if(calendars?.contains(0) ?? false){
                    event = EKEvent(eventStore: eventStore)
                    event.title = "it's \(prayerName) time"
                    event.startDate = eventStartDate ?? Date()
                    event.endDate = eventStartDate ?? Date()
                    event.notes = ""
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    appleEvents.append(event)
                }
                if(calendars?.contains(1) ?? false){
                    googleEventObj = EventData(title: "it's \(prayerName) time", description: "", eventStartDate: googleFormatter.string(from: eventStartDate ?? Date()), eventEndDate: googleFormatter.string(from: eventEndDate ?? Date()))
                    googleEvents.append(googleEventObj)
                    
//                    self.addEventToGoogleCalendar(title: "it's \(prayerName) time", description: "", eventStartDate:googleFormatter.string(from: eventStartDate ?? Date()), eventEndDate: googleFormatter.string(from: eventEndDate ?? Date()), decodedservice: decodedservice)
//
                }
                if(calendars?.contains(2) ?? false){
                   microsoftEventObj = EventData(title: "it's \(prayerName) time", description: "", eventStartDate: MSFormatter.string(from: eventStartDate ?? Date()), eventEndDate: MSFormatter.string(from: eventEndDate ?? Date()))
                    microsoftEvents.append(microsoftEventObj)
//                    self.addEventToMicrosoftCalendar(calendarId:microsoftCalendarID , title: "it's \(prayerName) time", description: "", eventStartDate:MSFormatter.string(from: eventStartDate ?? Date()), eventEndDate: MSFormatter.string(from: eventEndDate ?? Date()))
                }
            })
        })
        
        
        if(calendars?.contains(0) ?? false){
        addEventToAppleCalendar(events: appleEvents){ (success) -> Void in
            if(success){
                numberOfcalenderThatImportData += 1
                if(numberOfcalenderThatImportData == calendars?.count ?? 0){
                    DispatchQueue.main.async {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.view?.imoprtToCalendarsSuccess()
                    }
                }
            }
            }}
         if(calendars?.contains(1) ?? false){
            addEventToGoogleCalendar(events:googleEvents, decodedservice: decodedservice!){ (success) -> Void in
            if(success){
                numberOfcalenderThatImportData += 1
                if(numberOfcalenderThatImportData == calendars?.count ?? 0){
                    DispatchQueue.main.async {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.view?.imoprtToCalendarsSuccess()
                    }
                }
            }
        }
        }
         if(calendars?.contains(2) ?? false){
        addEventToMicrosoftCalendar(events:microsoftEvents,calendarId:microsoftCalendarID!){ (success) -> Void in
            if(success){
                numberOfcalenderThatImportData += 1
                if(numberOfcalenderThatImportData == calendars?.count ?? 0){
                    DispatchQueue.main.async {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.view?.imoprtToCalendarsSuccess()
                    }
                }
            }
        }
        }
    }
    
        
    
    
    /**
     Call this function to import PrayerTimes To Apple Calendar.
     
     ### Usage Example: ###
     ````
     addEventToAppleCalendar(events: appleEvents)
     ````
     - Parameters:
     - events : list of  events to be added to apple calendar .
     */
    func addEventToAppleCalendar(events:[EKEvent],completion:@escaping (Bool) -> ()){
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                for (index, event) in events.enumerated(){
                    //                events.forEach({ (event,index) in
                    do {
                        try self.eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                        //                    self.view?.showError(error: "failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                    if(index == events.count - 1){
                        completion(true)
                    }
                }
                
            }
            else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
    
    /**
     Call this function to import PrayerTimes To Microsoft Calendar.
     
     ### Usage Example: ###
     ````
     self.addEventListToMicrosoftCalendar(calendarId:id , title: "it's \(prayerName) time", description: "", eventStartDate:MSFormatter.string(from: eventStartDate ?? Date()), eventEndDate: MSFormatter.string(from: eventEndDate ?? Date()) , tillDate: importEndDateAsString)
     ````
     - Parameters:
     - calendarId : defaullt calender id to add the event to.
     - title : event title.
     - description:event description.
     - eventStartDate: event start date.
     - eventEndDate: event end date.
     - tillDate:repeat the event  till this date.
     
     */
    func  addEventToMicrosoftCalendar(events:[EventData], calendarId:String,completion:@escaping (Bool) -> ()){
        let token = UserDefaults.standard.value(forKey: UserDefaultsConstants.microsoftAuthorization) as! String
        let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)
        let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
        var urlRequest: NSMutableURLRequest? = nil
        if let url = URL(string: MSGraphBaseURL + ("me/calendars/" + "\(calendarId)" + "/events")) {
            urlRequest = NSMutableURLRequest(url: url)
        }
        urlRequest?.httpMethod = "POST"
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        for (index,microsoftEvent) in events.enumerated(){
        
            let event = ["subject":microsoftEvent.title , "body":["contentType" : "text"],"start" :["dateTime":microsoftEvent.eventStartDate , "timeZone":"UTC"],"end" :["dateTime":microsoftEvent.eventEndDate , "timeZone":"UTC"]] as [String : Any]
        do{
            let eventData = try JSONSerialization.data(withJSONObject: event, options: .prettyPrinted)
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
                if(index == events.count - 1){
                    completion(true)
                }
                
            })
        }
        
        meDataTask?.execute()
        }
        
    }
    /**
     Call this function to import PrayerTimes To Google Calendar.
     
     ### Usage Example: ###
     ````
     self.addEventListToGoogleCalendar(title: "it's \(prayerName) time", description: "", eventStartDate:googleFormatter.string(from: eventStartDate ?? Date()), eventEndDate: googleFormatter.string(from: eventEndDate ?? Date()) , tillDate: googleTillDateFormatter.string(from: tillEndDate ?? Date()).replacingOccurrences(of: "-", with: "") )
     ````
     - Parameters:
     - title : event title.
     - description:event description.
     - eventStartDate: event start date.
     - eventEndDate: event end date.
     - tillDate:repeat the event  till this date.
     
     */
//    func  addEventToGoogleCalendar(events:[EventData],decodedservice:GoogleService,completion:@escaping (Bool) -> ()){
//        for (index,event) in events.enumerated(){
//           let calendarEvent = GTLRCalendar_Event()
//            calendarEvent.summary = event.title
//            calendarEvent.descriptionProperty = event.description
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//            let startDate = dateFormatter.date(from: event.eventStartDate)
//            let endDate = dateFormatter.date(from: event.eventEndDate)
//
//        guard let toBuildDateStart = startDate else {
//            print("Error getting start date")
//            return
//        }
//        guard let toBuildDateEnd = endDate else {
//            print("Error getting end date")
//
//            return
//        }
//        calendarEvent.start = buildDate(date: toBuildDateStart)
//        calendarEvent.end = buildDate(date: toBuildDateEnd)
//
//        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
//            //        calendarEvent.recurrence = ["RRULE:FREQ=DAILY;UNTIL=\(tillDate)"]
//
//            decodedservice.executeQuery(insertQuery) { (ticket, object, error) in
//                if error == nil {
//                    print("Event inserted")
//                } else {
//                    print("event not added with title \(event.title) at \(event.eventStartDate)")
//                }
//                if(index == events.count - 1){
//                    completion(true)
//                }
//        }
//        }
//    }
    func  addEventToGoogleCalendar(events:[EventData],decodedservice:GoogleService,completion:@escaping (Bool) -> ()){
        print(events.count)
       let result = events.chunked(into: 50)
        var batchQuery = GTLRBatchQuery()
     for (index,batch) in result.enumerated(){
        print(batch.count)
       batchQuery = GTLRBatchQuery()

         batch.forEach({ (event) in
           let calendarEvent = GTLRCalendar_Event()
            calendarEvent.summary = event.title
            calendarEvent.descriptionProperty = event.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let startDate = dateFormatter.date(from: event.eventStartDate)
            let endDate = dateFormatter.date(from: event.eventEndDate)
        
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
            //        calendarEvent.recurrence = ["RRULE:FREQ=DAILY;UNTIL=\(tillDate)"]
         batchQuery.addQuery(insertQuery)
        })
           decodedservice.executeQuery(batchQuery) { (ticket, object, error) in
               if error == nil {
                   print("Event inserted")
                  
               } else {
                   print("event not added with title ")
               }
            if(index == result.count - 1){
                completion(true)
            }
             
        }

        }
     
    }
    /**
     Call this function to build google calendar date object
     
     ### Usage Example: ###
     ````
     buildDate(date: toBuildDateStart)
     ````
     - Parameters:
     - date : the date used to generate GTLRCalendar.
     
     */
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let timeZone = NSTimeZone.system
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        dateObject.timeZone=timeZone.identifier
        return dateObject
    }
}
