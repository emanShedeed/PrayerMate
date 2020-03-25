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
class PrayerTimeCell: UITableViewCell {
    @IBOutlet weak var prayerTimeNameLbl:UILabel!
    @IBOutlet weak var prayerTimeLbl:UILabel!
    @IBOutlet weak var isSelectedPrayerTimeBtn:UIButton!
    
    weak var cellDelegate:PrayerTimeCellDelegate?
    var cellIndex:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSelectedPrayerTimeBtn.setImage(UIImage.unselectedPrayerTime, for: .normal)
        isSelectedPrayerTimeBtn.setImage(UIImage.selectedPrayerTime, for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func checkPrayerTimeBtnPressed(_ sender: Any) {
        cellDelegate?.customCell(cell: self, checkedButonatCellIndex: cellIndex)
    }
    
}
extension PrayerTimeCell:PrayerTimeCellView{
    func displayData(prayerTimeName: String, prayerTime: String, isCellSelected: Bool,isBtnChecked:Bool,cellIndex:Int) {
        self.cellIndex = cellIndex
        prayerTimeNameLbl.text=prayerTimeName
//        if(AppSetting.shared.getCurrentLanguage() == .ar){
//            prayerTimeLbl.text=prayerTime.EnToARDigits.replacingOccurrences(of: "pm", with: "مساءا").replacingOccurrences(of: "am", with: "صباحا")
//        }else{
            prayerTimeLbl.text=prayerTime
//        }
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
