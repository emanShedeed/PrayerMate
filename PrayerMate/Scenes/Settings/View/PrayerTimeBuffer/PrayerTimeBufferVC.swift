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
        if(presenter.getToggleValue()){
        automaticAdjustBufferLbl.text = presenter.getbufferText(index: 0)
        }else{
           automaticAdjustBufferLbl.text = ""
        }
        automaticAdjustBufferSwitch.isOn = presenter.getToggleValue()
    }
    
    
    @IBAction func automaticAdjustBufferSwichPressed(_ sender: UISwitch) {
        if(sender.isOn){
        createActionSheet(forAll: true, index: 0, type: "M", before: 15, after: 15)
        }else{
            presenter.setToggleValue(value: false)
            automaticAdjustBufferLbl.text = ""
        }
    }
    func createActionSheet(forAll:Bool = false, index: Int , type:String,  before:Int, after:Int){
        let actionSheetController=UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        // create an action
        let defaultMinuteBeforeAndAfter = UIAlertAction(title: "PrayerTimeBufferVC.actionSheetDefault".localized, style: .default) { action -> Void in
            if(forAll){
                self.presenter.setToggleValue(value: true)
            }
            self.presenter.setbuffer(forAll: forAll, index: index, type: type, beforeValue: before, afterValue: after)
           
            }
        defaultMinuteBeforeAndAfter.setValue(UIColor.black, forKey: "titleTextColor")
        // create an action
        let customAction = UIAlertAction(title: "PrayerTimeBufferVC.actionSheetCustom".localized, style: .default) { action -> Void in
          
        }
        customAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        // create an action
        let doneAction = UIAlertAction(title: "Language.done".localized, style: .cancel) { action -> Void in }
        doneAction.setValue(UIColor(rgb: 0xEA961E), forKey: "titleTextColor")
        
        // add actions
        actionSheetController.addAction(defaultMinuteBeforeAndAfter)
        actionSheetController.addAction(customAction)
        actionSheetController.addAction(doneAction)
        
        self.present(actionSheetController, animated: true) {
            print("option menu presented")
        }
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
        createActionSheet(forAll: false, index:indexPath.row, type: "M", before: 15, after: 15)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 57.0
       }
    
}
