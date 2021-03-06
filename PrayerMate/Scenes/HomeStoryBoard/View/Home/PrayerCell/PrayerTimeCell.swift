//
//  PrayerTimeCell.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

protocol PrayerTimeCellDelegate:class {
    func customCell(cell:PrayerTimeCell, checkedButonatCellIndex:Int)
}
/// This is a class created for prayer time Cell At Home View
class PrayerTimeCell: UITableViewCell {
    //MARK:- IBOUTLET
    @IBOutlet weak var prayerTimeNameLbl:UILabel!
    @IBOutlet weak var prayerTimeLbl:UILabel!
    @IBOutlet weak var isSelectedPrayerTimeBtn:UIButton!
    //MARK:VARiIABLES
    weak var cellDelegate:PrayerTimeCellDelegate?
    var cellIndex:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSelectedPrayerTimeBtn.setImage(UIImage.unselectedPrayerTime, for: .normal)
        isSelectedPrayerTimeBtn.setImage(UIImage.selectedPrayerTime, for: .selected)
    }
    //MARK:- IBActions
    @IBAction func checkPrayerTimeBtnPressed(_ sender: Any) {
        cellDelegate?.customCell(cell: self, checkedButonatCellIndex: cellIndex)
    }
    
}
/// This is a class created  to conform to PrayerTimeCellView protcol to display data
extension PrayerTimeCell:PrayerTimeCellView{
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int) {
        self.cellIndex = cellIndex
        prayerTimeNameLbl.text=prayerTimeName
        prayerTimeLbl.text=prayerTime
        isSelectedPrayerTimeBtn.setImage((isBtnChecked ? UIImage.selectedPrayerTime : UIImage.unselectedPrayerTime) , for: .normal)
        if(isCellSelected){
            prayerTimeNameLbl.textColor=UIColor(rgb: 0x20DF7F)
            prayerTimeLbl.textColor=UIColor(rgb: 0x20DF7F)
        }else{
            prayerTimeNameLbl.textColor = .white
            prayerTimeLbl.textColor = .white
        }
    }
}
