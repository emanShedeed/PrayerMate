//
//  PrayerTimeBufferVCPresenter.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/2/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
protocol  PrayerTimeBufferView :class{
    func showError(error:String)
    func setBufferSucess()
    
}
protocol PrayerTimeBufferCellView {
    func displayData(prayerTimeName: String, prayerTimeBuffer: String,iconImage: UIImage)
}
/// This is a presenter class created for handling MovesHomeVC Functions.
class PrayerTimeBufferVCPresenter{
    private weak var view : PrayerTimeBufferView?
    let prayerTimesNames=["PrayerTimeBufferVC.fajrPrayerLblTitle","PrayerTimeBufferVC.sunrisePrayerLblTitle","PrayerTimeBufferVC.zuhrPrayerLblTitle","PrayerTimeBufferVC.asrPrayerLblTitle","PrayerTimeBufferVC.maghribPrayerLblTitle","PrayerTimeBufferVC.ishaPrayerLblTitle"]
       let iconImagesArray = [UIImage.fajrIcon,UIImage.sunriseIcon,UIImage.zuhrIcon,UIImage.asrIcon,UIImage.maghribIcon,UIImage.ishaIcon]
       
       var automaticAdjustBufferBeforeText = ""
       var automaticAdjustBufferAfterText = ""
       var prayerTimesBufferArray : [PrayerTimeBuffer]?
    
    init(view:PrayerTimeBufferView) {
        self.view=view
        let fetchedData = UserDefaults.standard.data(forKey: "prayerTimesBufferArray")!
        prayerTimesBufferArray = try! PropertyListDecoder().decode([PrayerTimeBuffer].self, from: fetchedData)

    }
   
  
    func getbufferText(index : Int) -> String {
      automaticAdjustBufferBeforeText = ""
        automaticAdjustBufferAfterText = ""
            if let type = prayerTimesBufferArray?.first?.type{
                if(type == "M"){
                    
                    automaticAdjustBufferBeforeText = "\(prayerTimesBufferArray?[index].before ?? 15 )" + "PrayerTimeBufferVC.minsBefore".localized
                    
                    automaticAdjustBufferAfterText = "\(prayerTimesBufferArray?[index].after ?? 15)" + "PrayerTimeBufferVC.minsAfter".localized
                }
                else if(type == "H"){
                    
                    automaticAdjustBufferBeforeText = "\(prayerTimesBufferArray?[index].before ?? 15 )" + "PrayerTimeBufferVC.hoursBefore".localized
                    
                    automaticAdjustBufferAfterText = "\(prayerTimesBufferArray?[index].after ?? 15)" + "PrayerTimeBufferVC.hoursAfter".localized
                    
                }
            }
            return automaticAdjustBufferBeforeText + automaticAdjustBufferAfterText
    }
    func setbuffer(forAll: Bool = false, index : Int, type:String, beforeValue:Int, afterValue:Int){
    
        if (forAll){
            let count = prayerTimesBufferArray?.count ?? 0
            for i in 0..<count{
                prayerTimesBufferArray?[i].type = type
                prayerTimesBufferArray?[i].before = beforeValue
                prayerTimesBufferArray?[i].after = afterValue
            }
        }else{
            prayerTimesBufferArray?[index].type = type
            prayerTimesBufferArray?[index].before = beforeValue
            prayerTimesBufferArray?[index].after = afterValue
        }
        view?.setBufferSucess()
    }
    func getToggleValue() -> Bool{
        return UserDefaults.standard.value(forKey: "automaticAdjustBufferToggle") as? Bool ?? false
    }
    func setToggleValue(value:Bool){
        UserDefaults.standard.set(value, forKey: "automaticAdjustBufferToggle")
       }
    func ConfigureCell(cell:PrayerTimeBufferCellView,cellIndex:Int){
        let text = getbufferText(index: cellIndex)
        cell.displayData(prayerTimeName: prayerTimesNames[cellIndex].localized, prayerTimeBuffer: text,iconImage: iconImagesArray[cellIndex]!)
          
      }
}
