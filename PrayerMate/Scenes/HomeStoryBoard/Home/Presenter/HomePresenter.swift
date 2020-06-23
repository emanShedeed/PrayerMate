//
//  HomeVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation

import RealmSwift


protocol  HomeViewControllerProtocol :class {
    func showError(error:String)
    func showIndicator()
    func fetchDataSucess()
 
}
protocol UpdateHomePrayerTimeCellProtcol {
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,cellIndex:Int)
}
/// This is a presenter class created for handling HomeVC Functions.
class HomePresenter{
    
    //MARK:VARiIABLES
    
    private weak var view : HomeViewControllerProtocol?
    init(view:HomeViewControllerProtocol) {
        self.view=view
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
    func ConfigureCell(cell:UpdateHomePrayerTimeCellProtcol,isCellSelected:Bool,cellIndex:Int){
        
        cell.displayData(prayerTimeName: prayerTimesNames[cellIndex].localized, prayerTime: todayParyerTimes[cellIndex] , isCellSelected:isCellSelected,cellIndex:cellIndex)
        
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
        UIApplication.shared.beginIgnoringInteractionEvents()
        if Helper.isConnectedToNetwork(){
            
            let task = URLSession.shared.dataTask(with: FINAL_URL){
                (data,response,error) in
                
                if let URLresponse = response {
                    print(URLresponse)
                }
                if let URLerror = error {
                    print(URLerror)
                    self.view?.showError(error:"\(URLerror))")
                }
                if let URLdata = data {
                    print(URLdata)
                    do{
                         let times = try JSONDecoder().decode([PrayerTimesResponseModel].self, from: URLdata)
                        if times.count != 0{
                            //                            print(prayerTimes.items?[0].dateFor)
                            let todayTimes=times[0].prayerTimeitems
                            self.todayParyerTimes = [(todayTimes?.fajr ?? ""),(todayTimes?.shurooq ?? ""),(todayTimes?.dhuhr ?? ""),(todayTimes?.asr ?? ""),(todayTimes?.maghrib ?? ""),(todayTimes?.isha ?? "")]
                              UserDefaults.standard.set( self.todayParyerTimes, forKey: UserDefaultsConstants.todayParyerTimes)
                            self.annualPrayerTimes = times
                            self.view?.fetchDataSucess()
                            DispatchQueue.main.async {
                                   UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }else{
                            self.view?.showError(error: "Home.errorGettingAPIdata".localized)
                              UIApplication.shared.beginIgnoringInteractionEvents()
                        }
                        
                    }catch {
                        print("Error: \(error)")
                        self.view?.showError(error: "Home.errorGettingAPIdata".localized)
                          UIApplication.shared.beginIgnoringInteractionEvents()
                    }
                    
                }
            }
            
            task.resume()
            
        }else{
            self.view?.showError(error: "internetFailMessage".localized)
        }
       
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
           view?.showIndicator()
            dataRequest(FINAL_URL:final_url)
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
        let addressTitle = UserDefaults.standard.value(forKey: UserDefaultsConstants.addressTitle) as? String ?? ""
        let method = UserDefaults.standard.value(forKey: UserDefaultsConstants.calendarMethod) as! [String:String]
        let methodID = method["methdID"] ?? "6"
        let userLocation =   UserDefaults.standard.value(forKey: UserDefaultsConstants.userLocation) as! [String:Double]
        let lat = userLocation["lat"]!
        let long = userLocation["long"]!
        let queryItems = [URLQueryItem(name: "method", value: methodID), URLQueryItem(name: "lat", value: "\(lat)"), URLQueryItem(name: "long", value: "\(long)"), URLQueryItem(name: "date", value: date), URLQueryItem(name: "location", value: addressTitle)]
        
//        let basicURL = Constants.apiBasicURL +  addressTitle + "/yearly/" + date + "\(lat)" + "\(long)"
//        let urlString = basicURL + "/false/" + methodID
//        print(urlString)
//        let ecnodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let url = URL(string: ecnodingString ?? "")
        var urlComps = URLComponents(string: Constants.apiBasicURL)!
        urlComps.queryItems=queryItems
        print(urlComps.url)
        return urlComps.url
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
            view?.showError(error: "Error intialize Realm \(error)")
        }
        
        annualPrayerTimes?.forEach { (item) in
            let prayerTimeObject = RealmPrayerTimeModel()
            prayerTimeObject.id = prayerTimeObject.incrementID()
            prayerTimeObject.date = item.prayerTimeitems?.dateFor ?? ""
            prayerTimeObject.fajr = item.prayerTimeitems?.fajr ?? ""
            prayerTimeObject.shurooq = item.prayerTimeitems?.shurooq ?? ""
            prayerTimeObject.dhuhr = item.prayerTimeitems?.dhuhr ?? ""
            prayerTimeObject.asr = item.prayerTimeitems?.asr ?? ""
            prayerTimeObject.maghrib = item.prayerTimeitems?.maghrib ?? ""
            prayerTimeObject.isha = item.prayerTimeitems?.isha ?? ""
            do{
                try realm.write{
                    realm.add(prayerTimeObject)
                }
            }catch{
                print("Error intialize Real \(error)")
                view?.showError(error: "Error intialize Real \(error)")
            }
            
        }
//       let _ = PrayerTimeLocalNotification()
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

