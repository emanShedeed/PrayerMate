//
//  PrayerTimeAnnual.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/22/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation

// MARK: - PrayerTimes
struct PrayerTimes: Codable {
    let items: [Item]?
    let statusValid, statusCode: Int?
    let statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case items
        case statusValid = "status_valid"
        case statusCode = "status_code"
        case statusDescription = "status_description"
    }
}

// MARK: - Item
struct Item: Codable {
    let dateFor, fajr, shurooq, dhuhr: String?
    let asr, maghrib, isha: String?

    enum CodingKeys: String, CodingKey {
        case dateFor = "date_for"
        case fajr, shurooq, dhuhr, asr, maghrib, isha
    }
}

