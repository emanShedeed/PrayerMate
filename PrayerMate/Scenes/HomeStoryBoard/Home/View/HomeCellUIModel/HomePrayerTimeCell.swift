//
//  PrayerTimeCell.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit


/// This is a class created for prayer time Cell At Home View
class HomePrayerTimeCell: UITableViewCell {
    //MARK:- IBOUTLET
    @IBOutlet weak var prayerTimeNameLbl:UILabel!
    @IBOutlet weak var prayerTimeLbl:UILabel!

    //MARK:VARiIABLES
    var cellIndex:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }
 
    
}
/// This is a class created  to conform to UpdatePrayerTimeCellProtcol  to display data
extension HomePrayerTimeCell:UpdateHomePrayerTimeCellProtcol{
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,cellIndex:Int) {
        self.cellIndex = cellIndex
        prayerTimeNameLbl.text=prayerTimeName
        prayerTimeLbl.text=prayerTime
        if(isCellSelected){
            prayerTimeNameLbl.textColor=UIColor(rgb: 0x20DF7F)
            prayerTimeLbl.textColor=UIColor(rgb: 0x20DF7F)
        }else{
            prayerTimeNameLbl.textColor = .white
            prayerTimeLbl.textColor = .white
        }
    }
}
