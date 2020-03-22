//
//  HomeVC+PrayerTimeCellDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
extension HomeVC:PrayerTimeCellDelegate{
    func customCell(cell: PrayerTimeCell, checkedButonatCellIndex: Int) {
        prayerTimesArray[checkedButonatCellIndex].isBtnChecked = !(prayerTimesArray[checkedButonatCellIndex].isBtnChecked)
        prayerTimestableView.reloadData()
        
    }

    

}
