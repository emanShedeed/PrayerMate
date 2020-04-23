//
//  LocalNotification.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/23/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import RealmSwift
class LocalNotification {
    var notificationArray : [Notification] = .init()
    let formatter=DateFormatter()
    init() {
        let realm = try! Realm()
        formatter.dateFormat = "yyyy-M-d"
        formatter.locale=NSLocale(localeIdentifier: "en") as Locale
        let predicate = NSPredicate(format: "date = %@ ", formatter.string(from: Date()))
        let firstImportDateObjFromRealm = realm.objects(RealmPrayerTimeModel.self).filter(predicate).first
        if let id = firstImportDateObjFromRealm?.id {
           let pericateToGetAllObjects = NSPredicate(format: "id BETWEEN { %ld,  %ld}",id,Int(id + 9))
           let  objects = realm.objects(RealmPrayerTimeModel.self).filter(pericateToGetAllObjects)
            objects.forEach { (day) in
                notificationArray.append(Notification(name: "fajr", time: day.fajr))
                  notificationArray.append(Notification(name: "Sunrise", time: day.shurooq))
                  notificationArray.append(Notification(name: "Zuhr", time: day.dhuhr))
                  notificationArray.append(Notification(name: "Asr", time: day.asr))
                  notificationArray.append(Notification(name: "Maghrib", time: day.maghrib))
                  notificationArray.append(Notification(name: "ISha", time: day.isha))
            }
            
        }
    }
}
