//
//  QuestionCell.swift
//  Ataba
//
//  Created by eman shedeed on 11/6/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit
/// This is a class created for Question Cell At FAQC VC
class QuestionCell: UITableViewCell {
    //MARK:- IBOUTLET
    @IBOutlet weak var questionTitleLbl:UILabel!
    @IBOutlet weak var questionAnswerLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let lang = AppSetting.shared.getCurrentLanguage()
          questionTitleLbl.textAlignment = (lang == .ar ? .right : .left)
           questionAnswerLbl .textAlignment =  questionTitleLbl.textAlignment
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     
     /**
          Call this function for configure cell
        
            
          ### Usage Example: ###
          ````
          dislayData()
          
          ````
           - Parameters:
               - title : question title.
               - answer : question answer.
       
          */
    func dislayData(title:String,answer:String){
        questionTitleLbl.text=title
        questionAnswerLbl.text=answer
    }
}
