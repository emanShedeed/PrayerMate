//
//  HomeVC+PrayerTimeCellDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
/// This is a class created for conform to PrayerTimeCellDelegate to Update Home UI when radio button checked 
extension HomeVC:PrayerTimeCellDelegate{
    func customCell(cell: PrayerTimeCell, checkedButonatCellIndex: Int) {
        prayerTimesArray[checkedButonatCellIndex].isBtnChecked = !(prayerTimesArray[checkedButonatCellIndex].isBtnChecked)
          numberOfSelectedPrayerTimes = 0
        prayerTimestableView.reloadData()
        
    }

    

}
