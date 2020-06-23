//
//  ExportingViewController.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/4/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
//import JTAppleCalendar
class ExportingViewController: BaseViewController {
    
    
    //MARK:- IBOUTLET
    
    
    @IBOutlet weak var prayerTimestableView: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var closeCalendarViewBtn: UIButton!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var automaticSelectPrayerTimeswitch: UISwitch!
    
    //MARK:VARiIABLES
    let titleLabel=UILabel()
    let countDownTimerFormatter = DateFormatter()
    var countdown: DateComponents!
    let calendar = Calendar.current
    var nextPrayerDateDate: Date!
    var numberOfSelectedPrayerTimes : Int = 0
    var presenter:ExportingPresenter!
    var prayerTimesArray: [(isCellSelected: Bool, isBtnChecked:Bool)] = .init()
    
    
    ///
    var selectedPrayerTimesIndicies: [Int] = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setUpNavBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          prayerTimesArray = [(Bool,Bool)]( repeating: (false,false), count: 6 )
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        
          importBtn.applyGradient(with:  [UIColor.exportBtnG2!, UIColor.exportBtnG1!], gradient: .horizontal)
    }
    //MARK:- Methods
    
    /**
     Call this function for setup the View UI
     
     
     ### Usage Example: ###
     ````
     setupView()
     
     ````
     - Parameters:
     */
    func setupView(){
        presenter = ExportingPresenter(view: self)
        countDownTimerFormatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        countDownTimerFormatter.dateFormat = "hh:mm:ss a"

       styleNavBar()
        if(UIScreen.main.bounds.height>667){
                 navigationViewHeight.constant = 100.0
               }else{
                 navigationViewHeight.constant = 66.0
             }
    }
    
    
    
    func setUpNavBar(){
          styleNavBar()
          TransparentNavBar()
          let backButton = UIBarButtonItem()
          backButton.title = "ExportingVC.navigationBackButton".localized
          self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    @IBAction func exportBtnPressed(_ sender: Any) {

        let alert=UIAlertController(title: "ExportingVC.alertTitle".localized, message: "ExportingVC.alertMessage".localized, preferredStyle: .alert)
        let okAction=UIAlertAction(title: "ExportingVC.continueBtnTitle".localized, style: .default) { (action) in
                    self.showPopover()
                  }
        let cancelAction=UIAlertAction(title: "ExportingVC.cancelBtnTitle".localized, style: .cancel) { (action) in
                  }
                  alert.addAction(okAction)
                  alert.addAction(cancelAction)
         if(numberOfSelectedPrayerTimes > 0){
         self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func automaticSelectPrayerTimeswichPressed(_ sender: UISwitch) {
        if(sender.isOn){
     prayerTimesArray = [(Bool,Bool)]( repeating: (true,true), count: 6 )
            numberOfSelectedPrayerTimes = 6
        }else{
          prayerTimesArray = [(Bool,Bool)]( repeating: (false,false), count: 6 )
            numberOfSelectedPrayerTimes = 0
        }
        saveSelectedPrayerTimesIndicies()
        prayerTimestableView.reloadData()
    }
    
    
    func saveSelectedPrayerTimesIndicies(){
        self.selectedPrayerTimesIndicies = self.prayerTimesArray.indices.filter{self.prayerTimesArray[$0].isBtnChecked == true}
        UserDefaults.standard.set(self.selectedPrayerTimesIndicies, forKey: UserDefaultsConstants.selectedPrayerTimesIndicies)
    }
    
}
/// This is a class created for handling table View delegate and data source delegate functions
extension ExportingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ExportingPrayerTimeCell", for: indexPath)as! ExportingPrayerTimeCell
        presenter.ConfigureCell(cell:cell, isCellSelected: prayerTimesArray[indexPath.row].isBtnChecked,isChecked:prayerTimesArray[indexPath.row].isBtnChecked,cellIndex:indexPath.row)
       numberOfSelectedPrayerTimes = prayerTimesArray[indexPath.row].isBtnChecked ? numberOfSelectedPrayerTimes + 1 : numberOfSelectedPrayerTimes
        cell.cellDelegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToRoomDetailsVC", sender: self)
//        numberOfSelectedPrayerTimes += 1
//        for index in 0 ..< prayerTimesArray.count {
//            prayerTimesArray[index].isCellSelected = false
//        }
        prayerTimesArray[indexPath.row].isCellSelected =  !(prayerTimesArray[indexPath.row].isCellSelected)
        
        prayerTimesArray[indexPath.row].isBtnChecked = !(prayerTimesArray[indexPath.row].isBtnChecked)
        
         
        
      saveSelectedPrayerTimesIndicies()
        prayerTimestableView.reloadData()
    }
    
    
    
}

extension ExportingViewController:UIPopoverPresentationControllerDelegate{
    func showPopover() {
        let buttonFrame = self.navigationController?.navigationBar.frame
        /* Rest is same as showing popoer */
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "ExportingPopUpViewController") as? ExportingPopUpViewController
        popoverContentController?.modalPresentationStyle = .popover
        
        
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = []
            popoverPresentationController.sourceView = self.view
            
            popoverPresentationController.sourceRect = CGRect(x: (buttonFrame?.maxX)! - 30, y: self.view.frame.height/2
                , width: 0, height: 0)
            
            popoverContentController!.preferredContentSize = CGSize(width : self.view.frame.width, height: 220)
            popoverPresentationController.delegate = self
            popoverContentController?.delegate=self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
