//
//  CustomActionVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/5/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
protocol UpdatePrayerTimesBufferProtcol:class {
    func didUpdateBuffer(forAll : Bool)
}

class CustomActionViewController: UIViewController {
    //MARK:- IBOUTLET
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var beforeRoundedView: UIView!
    @IBOutlet weak var afterRoundedView: UIView!
    @IBOutlet weak var beforeTxt: UITextField!
    @IBOutlet weak var afterTxt: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var MinutesBtn: UIButton!
    @IBOutlet weak var HoursBtn: UIButton!
    @IBOutlet var textFields: [UITextField]!
    //MARK:VARiIABLES
    var delegate:UpdatePrayerTimesBufferProtcol?
    var bufferType:String = "M"
    var index : Int = 0
    var forall : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    /**
     Call this function for setup the View UI
     
     
     ### Usage Example: ###
     ````
     setupView()
     
     ````
     - Parameters:
     */
    func setupView(){
        MinutesBtn.isSelected = true
        MinutesBtn.setImage(UIImage.unSelectedRadio, for: .normal)
        MinutesBtn.setImage(UIImage.selectedRadio, for: .selected)
        HoursBtn.setImage(UIImage.unSelectedRadio, for: .normal)
        HoursBtn.setImage(UIImage.selectedRadio, for: .selected)
        beforeTxt.placeholder="customActionVC.beforeTxtPlaceHolder".localized
        afterTxt.placeholder="customActionVC.afterTxtPlaceHolder".localized
        roundedView.roundCorners([.topLeft,.topRight], radius: 20)
        beforeRoundedView.layer.borderWidth = 1
        beforeRoundedView.layer.borderColor = UIColor(rgb: 0xEFEFEF).cgColor
        beforeRoundedView.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 5)
        afterRoundedView.layer.borderWidth = 1
        afterRoundedView.layer.borderColor = UIColor(rgb: 0xEFEFEF).cgColor
        afterRoundedView.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 5)
    }
    // MARK: - Helper Methods
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        if(bufferType == "M"){
            
            if textField == textFields[0] || textField == textFields[1]{
                
                let timeAsInt = Int(textField.text ?? "") ?? -1
                
                let test = timeAsInt >= 0 && timeAsInt <= 60
                
                return ( test, "customActionVC.minutesValidationMessage".localized)
            }
        }else if(bufferType == "H"){
            
            if textField == textFields[0] || textField == textFields[1]{
                
                let timeAsInt = Int(textField.text ?? "") ?? -1
                
                let test = timeAsInt >= 0 && timeAsInt <= 24
                
                return ( test, "customActionVC.hoursValidationMessage".localized)
            }
        }
        
        
        
        return (text.count > 0, "This field cannot be empty.")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            self.doneBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//         doneBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
//    }
    
    
    @IBAction func radioButtonPressed(_ sender: UIButton) {
        if(sender.tag == 1 ){
            bufferType = "M"
            MinutesBtn.isSelected=true
            HoursBtn.isSelected = false
        }else if(sender.tag == 2 ){
            bufferType = "H"
            HoursBtn.isSelected = true
            MinutesBtn.isSelected = false
        }
    }
    @IBAction func closeViewBtnPressed(_ sender: Any) {
        if(forall){
            UserDefaults.standard.set(false, forKey:UserDefaultsConstants.automaticAdjustBufferToggle)
        }
        delegate?.didUpdateBuffer(forAll: forall)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        var isCompleted=true
        for (index,textField) in textFields.enumerated(){
            let (valid, message) = validate(textField)
            //            validationLabels[index].text=message
            if(!valid){
                Helper.showToast(message: message ?? "")
                isCompleted=false
                // break
                
            }
        }
        if isCompleted{
            let presenter = PrayerTimeBufferPresenter(view: nil)
            if(forall){
                presenter.setToggleValue(value: true)
            }else{
                presenter.setToggleValue(value: false)
            }
            presenter.setbuffer(forAll: forall, index: index, type: bufferType, beforeValue: Int(beforeTxt?.text ?? "0") ?? 0, afterValue:Int(afterTxt?.text ?? "0") ?? 0)
            delegate?.didUpdateBuffer(forAll: forall)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
