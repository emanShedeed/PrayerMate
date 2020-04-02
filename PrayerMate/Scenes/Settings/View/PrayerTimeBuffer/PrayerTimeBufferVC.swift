//
//  PrayerTimeBufferVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/2/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class PrayerTimeBufferVC: BaseVC {
    
    @IBOutlet weak var PrayerTimeBufferTableView: UITableView!
    
    @IBOutlet weak var automaticAdjustBufferLbl: UILabel!
    
    @IBOutlet weak var automaticAdjustBufferSwitch: UISwitch!
    
    
    var presenter:PrayerTimeBufferVCPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
         presenter = PrayerTimeBufferVCPresenter(view: self)
        PrayerTimeBufferTableView.tableFooterView=UIView()
        // For remove last separator
        PrayerTimeBufferTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: PrayerTimeBufferTableView.frame.size.width, height: 1))
        if( presenter.getToggleValue()){
        automaticAdjustBufferLbl.text = presenter.getbufferText(index: 0)
        }else{
           automaticAdjustBufferLbl.text = ""
        }
        automaticAdjustBufferSwitch.isOn = presenter.getToggleValue()
    }
    
    
    @IBAction func automaticAdjustBufferSwichPressed(_ sender: Any) {
    }
    
}
extension PrayerTimeBufferVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.iconImagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTimeBufferCell", for: indexPath) as! PrayerTimeBufferCell
        presenter.ConfigureCell(cell: cell, cellIndex: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 57.0
       }
    
}
