//
//  HomeVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
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
}
