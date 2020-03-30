//
//  SettingsTV.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/29/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import UIKit

class SettingsTV: UITableViewController {

   @IBOutlet var settingsTableView: UITableView!
       override func viewDidLoad() {
           super.viewDidLoad()
           settingsTableView.tableFooterView=UIView()
       }
       
       // MARK: - Table view data source
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if(indexPath.section == 0){
               if(indexPath.row == 6){
                   performSegue(withIdentifier: "goToFrequentlyQuestionsVC", sender: nil)
               }
              /* else if(indexPath.row == 1){
               self.dismiss(animated: true, completion: nil)
               delegate?.shareRoomBtnPress(roomID:roomID!)
               }
               else if(indexPath.row == 2){
                   
                   let alert=UIAlertController(title: "", message: "Are You Sure You Want To Delete?", preferredStyle: .alert)
                   let okAction=UIAlertAction(title: "OK", style: .default) { (action) in
                       self.presenter.deleteRoom(roomId: self.roomID)
                   }
                   let cancelAction=UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                       //   self.dismiss(animated: true, completion: nil)
                   }
                   alert.addAction(okAction)
                   alert.addAction(cancelAction)
                   self.present(alert, animated: true, completion: nil)
                   
                   
               }*/
           }
       }

}
