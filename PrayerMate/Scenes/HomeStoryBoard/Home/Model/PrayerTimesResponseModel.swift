//
//  PrayerTimeAnnual.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/22/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation

// MARK: - PrayerTimes
struct PrayerTimesResponseModel: Codable {
    let prayerTimeitems: PrayerTimeItem?
    
    enum CodingKeys: String, CodingKey {
        case prayerTimeitems = "items"
    }
}
// MARK: - Item
struct PrayerTimeItem: Codable {
    let dateFor, fajr, shurooq, dhuhr: String?
    let asr, maghrib, isha: String?
    enum CodingKeys: String, CodingKey {
         case dateFor = "date_for"
         case fajr, shurooq, dhuhr, asr, maghrib, isha
     }
}

