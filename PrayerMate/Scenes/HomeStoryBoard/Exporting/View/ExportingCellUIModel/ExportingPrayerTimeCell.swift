//
//  ExportingCell.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/4/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//
import UIKit

protocol ExportingPrayerTimeCellProtcol:class {
    func customCell(cell:ExportingPrayerTimeCell, checkedButonatCellIndex:Int)
}
class ExportingPrayerTimeCell: UITableViewCell {
    //MARK:- IBOUTLET
    @IBOutlet weak var prayerTimeNameLbl:UILabel!
    @IBOutlet weak var prayerTimeLbl:UILabel!
    @IBOutlet weak var isSelectedPrayerTimeBtn:UIButton!
    //MARK:VARiIABLES
    weak var cellDelegate:ExportingPrayerTimeCellProtcol?
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
/// This is a class created  to conform to UpdatePrayerTimeCellProtcol  to display data
extension ExportingPrayerTimeCell:UpdateExportingPrayerTimeCellProtcol{
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int) {
        self.cellIndex = cellIndex
        prayerTimeNameLbl.text=prayerTimeName
        prayerTimeLbl.text=prayerTime
        isSelectedPrayerTimeBtn.setImage((isBtnChecked ? UIImage.selectedPrayerTime : UIImage.unselectedPrayerTime) , for: .normal)
        if(isCellSelected){
            prayerTimeNameLbl.textColor=UIColor(rgb: 0x20DF7F)
            prayerTimeLbl.textColor=UIColor(rgb: 0x20DF7F)
        }else{
            prayerTimeNameLbl.textColor = UIColor(rgb: 0x3C3C3C)
            prayerTimeLbl.textColor = UIColor(rgb: 0x3C3C3C)
        }
    }
}
