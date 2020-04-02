//
//  PrayerTimeBufferCell.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/2/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class PrayerTimeBufferCell: UITableViewCell {
    @IBOutlet weak var prayerTimeIcon:UIImageView!
    @IBOutlet weak var prayerTimeNameLbl:UILabel!
    @IBOutlet weak var prayerTimebufferLbl:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension PrayerTimeBufferCell:PrayerTimeBufferCellView{
    func displayData(prayerTimeName: String, prayerTimeBuffer: String, iconImage: UIImage) {
        prayerTimeNameLbl.text = prayerTimeName
        prayerTimebufferLbl.text = prayerTimeBuffer
        prayerTimeIcon.image = iconImage
    }
}
