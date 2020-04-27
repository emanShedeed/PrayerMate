//
//  LocalNotification.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/23/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications
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
            var  notificationDate : Date? = Date()
            objects.forEach { (day) in
                notificationDate = formatter.date(from: day.date)
                notificationArray.append(Notification(name: "fajrPrayerNotificationTitle".localized, time: day.fajr, date: notificationDate))
                notificationArray.append(Notification(name: "sunrisePrayerNotificationTitle".localized, time: day.shurooq, date: notificationDate))
                notificationArray.append(Notification(name: "zuhrPrayerNotificationTitle".localized, time: day.dhuhr, date: notificationDate))
                notificationArray.append(Notification(name: "asrPrayerNotificationTitle".localized, time: day.asr, date: notificationDate))
                notificationArray.append(Notification(name: "maghribPrayerNotificationTitle".localized, time: day.maghrib, date: notificationDate))
                notificationArray.append(Notification(name: "ishaPrayerNotificationTitle".localized, time: day.isha, date: notificationDate))
            }
            notificationArray.append(Notification(name: "openAppNotificationTitle".localized, time: objects[9].isha, date: notificationDate))
           registerLocal()
        }
    }
    func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.scheduleLocal()
            } else {
                Helper.showToast(message:"alertToEnableNotifications".localized)
            }
        }
    }
     func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        notificationArray.forEach { (notification) in
   
        let content = UNMutableNotificationContent()
            content.title = notification.name
//        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
//        content.categoryIdentifier = "alarm"
//        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
            let time = notification.time.split(separator: ":")
            var hour = Int(time[0])
            let minutes = time[1].split(separator: " ")
            hour = minutes[1].contains("pm") ? (hour ?? 0) + 12 : hour
            
            dateComponents.year = Calendar.current.component(.year, from: notification.date ?? Date())
            dateComponents.month = Calendar.current.component(.month, from: notification.date ?? Date())
            dateComponents.day = Calendar.current.component(.day, from: notification.date ?? Date())
            dateComponents.hour =  hour
            dateComponents.minute = Int(minutes[0])
            
            
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        }
    }
}
