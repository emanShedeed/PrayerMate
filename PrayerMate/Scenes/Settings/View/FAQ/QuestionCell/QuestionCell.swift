//
//  QuestionCell.swift
//  Ataba
//
//  Created by eman shedeed on 11/6/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet weak var questionTitleLbl:UILabel!
    @IBOutlet weak var questionAnswerLbl:UILabel!
    @IBOutlet weak var answerLblHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func dislayData(title:String,answer:String){
        questionTitleLbl.text=title
        questionAnswerLbl.text=answer
    }
}
