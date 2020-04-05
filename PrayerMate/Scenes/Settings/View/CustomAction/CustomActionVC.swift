//
//  CustomActionVC.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/5/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit
protocol UpdatePrayerTimesBufferView:class {
    func didUpdateBuffer(forAll : Bool)
}

class CustomActionVC: UIViewController {
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var beforeRoundedView: UIView!
    @IBOutlet weak var afterRoundedView: UIView!
    @IBOutlet weak var beforeTxt: UITextField!
    @IBOutlet weak var afterTxt: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var MinutesBtn: UIButton!
    @IBOutlet weak var HoursBtn: UIButton!
    
    
    var delegate:UpdatePrayerTimesBufferView?
    var bufferType:String = "M"
    var index : Int = 0
    var forall : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
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
    override func viewDidLayoutSubviews() {
        doneBtn.applyGradient(with:  [UIColor.init(rgb: 0x336666), UIColor.init(rgb: 0x339966)], gradient: .horizontal)
    }
    
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
        UserDefaults.standard.set(false, forKey: "automaticAdjustBufferToggle")
        }
        delegate?.didUpdateBuffer(forAll: forall)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let presenter = PrayerTimeBufferVCPresenter(view: nil)
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
