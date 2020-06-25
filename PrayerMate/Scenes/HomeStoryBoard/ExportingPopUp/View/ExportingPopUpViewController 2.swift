//
//  ExportingPopUpViewController.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/21/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
protocol  ExportingPopUpViewControllerProtocol{
    func importToCalendarsOkBtnPressed(withperiodSelected:Int)
}
class ExportingPopUpViewController: BaseViewController {
    @IBOutlet weak var sevendaysBtn : UIButton!
    @IBOutlet weak var fifteendaysBtn : UIButton!
    
    var delegate:ExportingPopUpViewControllerProtocol?
    var selectedPeriod : Int = 7
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    func setupView(){
        sevendaysBtn.isSelected = true
        sevendaysBtn.setImage(UIImage.unSelectedRadio, for: .normal)
        sevendaysBtn.setImage(UIImage.selectedRadio, for: .selected)
        fifteendaysBtn.setImage(UIImage.unSelectedRadio, for: .normal)
        fifteendaysBtn.setImage(UIImage.selectedRadio, for: .selected)
    }
    @IBAction func radioButtonPressed(_ sender: UIButton) {
        if(sender.tag == 1 ){
            selectedPeriod = 7
            sevendaysBtn.isSelected=true
            fifteendaysBtn.isSelected = false
        }else if(sender.tag == 2 ){
            selectedPeriod = 15
            sevendaysBtn.isSelected=false
            fifteendaysBtn.isSelected = true
        }
    }
    @IBAction func OkBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(selectedPeriod, forKey: UserDefaultsConstants.selectedExortingPeriod)
        self.dismiss(animated: true, completion: nil)
        delegate?.importToCalendarsOkBtnPressed(withperiodSelected: selectedPeriod)
    }
    @IBAction func CancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
