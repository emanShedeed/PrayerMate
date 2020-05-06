//
//  RealmPrayerTimeModel.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/14/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import RealmSwift
class RealmPrayerTimeModel: Object{
    @objc dynamic var id = 0
    @objc dynamic var date:String = ""
    @objc dynamic var fajr:String = ""
    @objc dynamic var shurooq:String = ""
    @objc dynamic var dhuhr:String = ""
    @objc dynamic var asr:String = ""
    @objc dynamic var maghrib:String = ""
    @objc dynamic var isha:String = ""
    
    override static func primaryKey() -> String? {
          return "id"
      }
//    //Incrementa ID
func incrementID() -> Int {
    let realm = try! Realm()
    return (realm.objects(RealmPrayerTimeModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
}
}

